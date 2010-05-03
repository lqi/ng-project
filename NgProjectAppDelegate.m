/**
 * Copyright 2010 Longyi Qi
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 */

#import "NgProjectAppDelegate.h"

@implementation NgProjectAppDelegate

@synthesize window;
@synthesize statusLabel;
@synthesize currentUser;
@synthesize inboxTableView;
@synthesize currentWave;
@synthesize versionInfo;
@synthesize participantAdd;
@synthesize participantList;
@synthesize waveTextView;
@synthesize tagAdd;
@synthesize tagList;

- (id)init {
	if (self = [super init]) {
		domain = @"192.168.131.5";
		participantId = [[NGParticipantId alloc] initWithDomain:domain participantId:@"test"];
		_seqNo = 0;
		idGenerator = [[NGRandomIdGenerator alloc] initWithDomain:domain];
		inboxViewDelegate = [[NGInboxViewDelegate alloc] init];
		inboxViewDelegate.currentUser = participantId;
		hasWaveOpened = NO;
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	network = [[NGNetwork alloc] initWithHostDomain:domain port:9876];
	
	[self.currentUser setStringValue:[participantId participantIdAtDomain]];
	
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(openInbox) userInfo:nil repeats:NO];
	
	[NSThread detachNewThreadSelector:@selector(connectionStatueControllerThread) toTarget:self withObject:nil];
	[NSThread detachNewThreadSelector:@selector(newReceiveThread) toTarget:self withObject:nil];
	
	[inboxTableView setDataSource:inboxViewDelegate];
	[inboxTableView setDoubleAction:@selector(openWave:)];
	
	[self.currentWave setStringValue:@"No open wave, double-click wave in the inbox"];
}

- (void) newReceiveThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	while (YES) {
		[NSThread sleepForTimeInterval:0.5];
		[self newReceive];
	}
	
	[pool release];
}

- (void) newReceive {
	if ([network isConnected]) {
		if ([network callbackAvailable]) {
			while (![[network pbInputStream] isAtEnd]) {
				NGRpcMessage *msg = [NGRpc receive:[network pbInputStream]];
				if ([[[[msg message] class] description] isEqual:@"ProtocolWaveletUpdate"]) {
					ProtocolWaveletUpdate *waveletUpdate = (ProtocolWaveletUpdate *)[msg message];
					NGWaveName *waveUrl = [[NGWaveName alloc] initWithString:[waveletUpdate waveletName]];
					NSString *updateWaveId = [[waveUrl waveId] waveId];
					if ([updateWaveId isEqual:@"indexwave!indexwave"]) {
						[inboxViewDelegate passSignal:waveletUpdate];
					}
					else if (hasWaveOpened && [updateWaveId isEqual:[self.waveTextView openWaveId]]) {
						self.waveTextView.waveletVersion = [[waveletUpdate resultingVersion] version];
						self.waveTextView.waveletHistoryHash = [[waveletUpdate resultingVersion] historyHash];
						[versionInfo setStringValue:[NSString stringWithFormat:@"%d, %@", self.waveTextView.waveletVersion, [self.waveTextView.waveletHistoryHash description]]];
						// mutation document for open wave
						
						for (ProtocolWaveletDelta *wd in [waveletUpdate appliedDeltaList]) {
							for (ProtocolWaveletOperation *op in [wd operationList]) {
								if ([op hasAddParticipant]) {
									[participantList addItemWithObjectValue:[[NGParticipantId participantIdWithParticipantIdAtDomain:[op addParticipant]] participantIdAtDomain]];
								}
								if ([op hasRemoveParticipant]) {
									[participantList removeItemWithObjectValue:[[NGParticipantId participantIdWithParticipantIdAtDomain:[op removeParticipant]] participantIdAtDomain]];
								}
								if ([op hasMutateDocument]) {
									ProtocolWaveletOperation_MutateDocument *md = [op mutateDocument];
									if ([[md documentId] isEqual:@"tags"]) {
										for (ProtocolDocumentOperation_Component *comp in [[md documentOperation] componentList]) {
											if ([comp hasCharacters]) {
												[tagList addItemWithObjectValue:[comp characters]];
											}
											if ([comp hasDeleteCharacters]) {
												[tagList removeItemWithObjectValue:[comp deleteCharacters]];
											}
										}
									}
									else {
										[self.waveTextView apply:[op mutateDocument]];
									}
								}
								if ([op hasNoOp]) {
									NSLog(@"TODO: No operation!");
								}
							}
						}
						
						// end mutation document for open wave
					}
					[waveUrl release];
					[inboxTableView reloadData];
				}
				else if ([[[[msg message] class] description] isEqual:@"ProtocolSubmitResponse"]) {
					NSLog(@"%d: Submit", [msg sequenceNo]);
				}
			}
		}
	}
}

- (IBAction) openWave:(id)sender {
	if (![network isConnected]) {
		return;
	}
	
	if (hasWaveOpened) {
		[self closeWave:nil];
	}
	
	NSInteger rowIndex = [inboxTableView clickedRow];
	NGWaveId *waveId = [[inboxViewDelegate getWaveIdByRowIndex:rowIndex] retain];
	hasWaveOpened = YES;
	
	[self.waveTextView openWithNetwork:network WaveId:[NGWaveId waveIdWithDomain:[waveId domain] waveId:[waveId waveId]] waveletId:[NGWaveletId waveletIdWithDomain:[waveId domain] waveletId:@"conv+root"] participantId:participantId sequenceNo:_seqNo];
	[self.currentWave setStringValue:[self.waveTextView openWaveId]];
	
	NGRpcMessage *message = [NGRpcMessage openRequest:waveId participantId:participantId seqNo:[self getSequenceNo]];
	[NGRpc send:message viaOutputStream:[network pbOutputStream]];
}

- (IBAction) closeWave:(id)sender {
	if (!hasWaveOpened) {
		return;
	}
	
	_seqNo = [self.waveTextView seqNo];
	hasWaveOpened = NO;
	[self.currentWave setStringValue:@"No open wave, double-click wave in the inbox"];
	[self.versionInfo setStringValue:@""];
	[self.participantAdd setStringValue:@""];
	[self.participantList removeAllItems];
	[self.participantList setStringValue:@""];
	[self.tagAdd setStringValue:@""];
	[self.tagList removeAllItems];
	[self.tagList setStringValue:@""];
	[self.waveTextView close];
}

- (void) connectionStatueControllerThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	while (YES) {
		[NSThread sleepForTimeInterval:0.5];
		[self connectionStatueController];
	}
	
	[pool release];
}

- (void) connectionStatueController {
	[self.statusLabel setStringValue:([network isConnected] ? @"Online": @"Offline")];
}

- (void) openInbox {
	if (![network isConnected]) {
		return;
	}
	NGWaveId *waveId = [NGWaveId waveIdWithDomain:@"indexwave" waveId:@"indexwave"];
	NGRpcMessage *message = [NGRpcMessage openRequest:waveId participantId:participantId seqNo:[self getSequenceNo]];
	[NGRpc send:message viaOutputStream:[network pbOutputStream]];	
}

- (IBAction) newWave:(id)sender {
	if (![network isConnected]) {
		return;
	}
	
	NGWaveName *newWaveName = [NGWaveName waveNameWithWaveId:[idGenerator newWaveId] andWaveletId:[idGenerator newConversationRootWaveletId]];
	NGDocumentId *newBlipName = [idGenerator newDocumentId];
	
	NGMutateDocument *newConversation = [[[[[[NGDocOpBuilder builder]
										 elementStart:@"conversation" withAttributes:[NGDocAttributes emptyAttribute]]
										 elementStart:@"blip" withAttributes:[[NGDocAttributes emptyAttribute] addAttributeWithKey:@"id" andValue:newBlipName]]
										 elementEnd]
										 elementEnd]
										 build];
	
	NGMutateDocument *newBlipOp = [[[[[[[[NGDocOpBuilder builder]
								   elementStart:@"contributor" withAttributes:[[NGDocAttributes emptyAttribute] addAttributeWithKey:@"name" andValue:[participantId participantIdAtDomain]]]
								   elementEnd]
								   elementStart:@"body" withAttributes:[NGDocAttributes emptyAttribute]]
								   elementStart:@"line" withAttributes:[NGDocAttributes emptyAttribute]]
								   elementEnd]
								   elementEnd]
								   build];
	
	NGWaveletDelta *newWaveletDelta = [[[[[NGWaveletDeltaBuilder builder:participantId] addParticipantOp:participantId] docOp:@"conversation" andMutateDocument:newConversation] docOp:newBlipName andMutateDocument:newBlipOp] build];
	
	NGRpcMessage *message = [NGRpcMessage submitRequest:newWaveName waveletDelta:newWaveletDelta hashedVersion:[NGHashedVersion hashedVersion:0 withHistoryHash:[[newWaveName url] dataUsingEncoding:NSUTF8StringEncoding]] seqNo:[self getSequenceNo]];
	
	[NGRpc send:message viaOutputStream:[network pbOutputStream]];	
}

- (IBAction) addParticipant:(id)sender {
	if (![network isConnected] || !hasWaveOpened) {
		return;
	}
	
	NGParticipantId *addParticipantId = [NGParticipantId participantIdWithParticipantIdAtDomain:[self.participantAdd stringValue]];
	NGWaveName *waveName = [NGWaveName waveNameWithWaveId:[NGWaveId waveIdWithDomain:domain waveId:[self.waveTextView openWaveId]] andWaveletId:[idGenerator newConversationRootWaveletId]];
	NGWaveletDelta *waveletDelta = [[[NGWaveletDeltaBuilder builder:participantId] addParticipantOp:addParticipantId] build];
	NGHashedVersion *hashedVersion = [NGHashedVersion hashedVersion:self.waveTextView.waveletVersion withHistoryHash:self.waveTextView.waveletHistoryHash];
	NGRpcMessage *message = [NGRpcMessage submitRequest:waveName waveletDelta:waveletDelta hashedVersion:hashedVersion seqNo:[self getSequenceNo]];
	[NGRpc send:message viaOutputStream:[network pbOutputStream]];
	
	[self.participantAdd setStringValue:@""];
}

- (IBAction) rmParticipant:(id)sender {
	if (![network isConnected] || !hasWaveOpened) {
		return;
	}
	
	NGParticipantId *rmParticipantId = [NGParticipantId participantIdWithParticipantIdAtDomain:[self.participantList stringValue]];
	NGWaveName *waveName = [NGWaveName waveNameWithWaveId:[NGWaveId waveIdWithDomain:domain waveId:[self.waveTextView openWaveId]] andWaveletId:[idGenerator newConversationRootWaveletId]];
	NGWaveletDelta *waveletDelta = [[[NGWaveletDeltaBuilder builder:participantId] removeParticipantOp:rmParticipantId] build];
	NGHashedVersion *hashedVersion = [NGHashedVersion hashedVersion:self.waveTextView.waveletVersion withHistoryHash:self.waveTextView.waveletHistoryHash];
	NGRpcMessage *message = [NGRpcMessage submitRequest:waveName waveletDelta:waveletDelta hashedVersion:hashedVersion seqNo:[self getSequenceNo]];
	[NGRpc send:message viaOutputStream:[network pbOutputStream]];
	
	[self.participantList setStringValue:@""];
}

- (IBAction) rmSelf:(id)sender {
	if (![network isConnected] || !hasWaveOpened) {
		return;
	}
	
	NGWaveName *waveName = [NGWaveName waveNameWithWaveId:[NGWaveId waveIdWithDomain:domain waveId:[self.waveTextView openWaveId]] andWaveletId:[idGenerator newConversationRootWaveletId]];
	NGWaveletDelta *waveletDelta = [[[NGWaveletDeltaBuilder builder:participantId] removeParticipantOp:participantId] build];
	NGHashedVersion *hashedVersion = [NGHashedVersion hashedVersion:self.waveTextView.waveletVersion withHistoryHash:self.waveTextView.waveletHistoryHash];
	NGRpcMessage *message = [NGRpcMessage submitRequest:waveName waveletDelta:waveletDelta hashedVersion:hashedVersion seqNo:[self getSequenceNo]];
	[NGRpc send:message viaOutputStream:[network pbOutputStream]];
	
	[self closeWave:nil];
}

- (IBAction) addTag:(id)sender {
	if (![network isConnected] || !hasWaveOpened) {
		return;
	}
	
	NGWaveName *waveName = [NGWaveName waveNameWithWaveId:[NGWaveId waveIdWithDomain:domain waveId:[self.waveTextView openWaveId]] andWaveletId:[idGenerator newConversationRootWaveletId]];
	
	NGDocOpBuilder *docOpBuilder = [NGDocOpBuilder builder];
	if ([self.tagList numberOfItems] != 0) {
		int retainItemCount = 0;
		for (NSString *thisTag in [self.tagList objectValues]) {
			retainItemCount += 2 + [thisTag length];
		}
		docOpBuilder = [docOpBuilder retain:retainItemCount];
	}
	NGMutateDocument *addTagDoc = [[[[docOpBuilder elementStart:@"tag" withAttributes:[NGDocAttributes emptyAttribute]] characters:[self.tagAdd stringValue]] elementEnd] build];
	NGWaveletDelta *waveletDelta = [[[NGWaveletDeltaBuilder builder:participantId] docOp:@"tags" andMutateDocument:addTagDoc] build];
	NGHashedVersion *hashedVersion = [NGHashedVersion hashedVersion:self.waveTextView.waveletVersion withHistoryHash:self.waveTextView.waveletHistoryHash];
	NGRpcMessage *message = [NGRpcMessage submitRequest:waveName waveletDelta:waveletDelta hashedVersion:hashedVersion seqNo:[self getSequenceNo]];
	[NGRpc send:message viaOutputStream:[network pbOutputStream]];
	
	[self.tagAdd setStringValue:@""];
}

- (IBAction) rmTag:(id)sender {
	if (![network isConnected] || !hasWaveOpened) {
		return;
	}
	
	NSString *tagToBeDeleted = [self.tagList stringValue];
	
	int retainItemCountBackward = 0;
	int retainItemCountForward = 0;
	int tagIndex = [self.tagList indexOfItemWithObjectValue:tagToBeDeleted];
	if (tagIndex != 0) {
		for (int i = 0; i < tagIndex; i++) {
			NSString *thisTag = [self.tagList itemObjectValueAtIndex:i];
			retainItemCountBackward += 2 + [thisTag length];
		}
	}
	if (tagIndex != ([self.tagList numberOfItems] - 1)) {
		for (int i = tagIndex + 1; i < [self.tagList numberOfItems]; i++) {
			NSString *thisTag = [self.tagList itemObjectValueAtIndex:i];
			retainItemCountForward += 2 + [thisTag length];
		}
	}
	
	NGWaveName *waveName = [NGWaveName waveNameWithWaveId:[NGWaveId waveIdWithDomain:domain waveId:[self.waveTextView openWaveId]] andWaveletId:[idGenerator newConversationRootWaveletId]];
	
	NGDocOpBuilder *docOpBuilder = [NGDocOpBuilder builder];
	if (retainItemCountBackward != 0) {
		docOpBuilder = [docOpBuilder retain:retainItemCountBackward];
	}
	docOpBuilder = [[[docOpBuilder deleteElementStart:@"tag"] deleteCharacters:tagToBeDeleted] deleteElementEnd];
	if (retainItemCountForward != 0) {
		docOpBuilder = [docOpBuilder retain:retainItemCountForward];
	}
	NGMutateDocument *rmTagDoc = [docOpBuilder build];
	NGWaveletDelta *waveletDelta = [[[NGWaveletDeltaBuilder builder:participantId] docOp:@"tags" andMutateDocument:rmTagDoc] build];
	NGHashedVersion *hashedVersion = [NGHashedVersion hashedVersion:self.waveTextView.waveletVersion withHistoryHash:self.waveTextView.waveletHistoryHash];
	NGRpcMessage *message = [NGRpcMessage submitRequest:waveName waveletDelta:waveletDelta hashedVersion:hashedVersion seqNo:[self getSequenceNo]];
	[NGRpc send:message viaOutputStream:[network pbOutputStream]];
	
	[self.tagList setStringValue:@""];
}

- (int) getSequenceNo {
	if (hasWaveOpened) {
		return [self.waveTextView seqNo];
	}
	else {
		return _seqNo++;
	}

}

- (void) dealloc {
	[inboxViewDelegate release];
	[participantId release];
	[idGenerator release];
	[network release];
	[super dealloc];
}

@end
