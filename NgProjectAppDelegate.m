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
		_domain = [NSString stringWithString:@"192.168.131.5"];
		_participantId = [[NGParticipantId alloc] initWithDomain:_domain participantId:@"test"];
		_idGenerator = [[NGIdGenerator alloc] initWithDomain:_domain];
		inboxViewDelegate = [[NGInboxViewDelegate alloc] init];
		inboxViewDelegate.currentUser = _participantId;
		_hasWaveOpened = NO;
		
		_host = [[NGHost alloc] init];
		_host.domain = _domain;
		_host.port = 9876;
		
		_channel = [[NGClientRpcChannel alloc] initWithHost:_host];
		
		_rpc = [[NGClientRpc alloc] init];
		[_rpc setChannel:_channel];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self.currentUser setStringValue:[_participantId participantIdAtDomain]];
	
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(openInbox) userInfo:nil repeats:NO];
	
	[inboxTableView setDataSource:inboxViewDelegate];
	[inboxTableView setDoubleAction:@selector(openWave:)];
	
	[self.currentWave setStringValue:@"No open wave, double-click wave in the inbox"];
}

- (void) receiveMessage:(PBGeneratedMessage *)message {
	if ([[[message class] description] isEqual:@"ProtocolWaveletUpdate"]) {
		ProtocolWaveletUpdate *waveletUpdate = (ProtocolWaveletUpdate *)message;
		NGWaveName *waveUrl = [[NGWaveName alloc] initWithString:[waveletUpdate waveletName]];
		NSString *updateWaveId = [[waveUrl waveId] waveId];
		if ([updateWaveId isEqual:@"indexwave!indexwave"]) {
			[inboxViewDelegate passSignal:waveletUpdate];
		}
		else if (_hasWaveOpened && [updateWaveId isEqual:[self.waveTextView openWaveId]]) {
			[self.waveTextView setHashedVersion:[[waveletUpdate resultingVersion] version] withHistoryHash:[[waveletUpdate resultingVersion] historyHash]];
			
			[versionInfo setStringValue:[[self.waveTextView hashedVersion] stringValue]];
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
	else if ([[[message class] description] isEqual:@"ProtocolSubmitResponse"]) {
		//NSLog(@"%d: Submit", [msg sequenceNo]);
	}
}

- (void) openInbox {
	NGClientRpcController *openInboxController = [[NGClientRpcController alloc] init];
	
	ProtocolOpenRequest_Builder *openInboxRequestBuilder = [ProtocolOpenRequest builder];
	[openInboxRequestBuilder setParticipantId:[_participantId participantIdAtDomain]];
	[openInboxRequestBuilder setWaveId:[[_idGenerator indexWaveId] waveIdFollowedByDomain]];
	
	NGClientRpcCallback *openInboxCallback = [[NGClientRpcCallback alloc] initWithApplication:self];
	
	[_rpc open:openInboxController request:[openInboxRequestBuilder build] callback:openInboxCallback];
}

- (IBAction) newWave:(id)sender {
	
	NGWaveName *newWaveName = [NGWaveName waveNameWithWaveId:[_idGenerator newWaveId] andWaveletId:[_idGenerator newConversationRootWaveletId]];
	NGDocumentId *newBlipName = [_idGenerator newDocumentId];
	
	NGMutateDocument *newConversation = [[[[[[NGDocOpBuilder builder]
										 elementStart:[NGDocumentConstant CONVERSATION] withAttributes:[NGDocAttributes emptyAttribute]]
										 elementStart:[NGDocumentConstant BLIP] withAttributes:[[NGDocAttributes emptyAttribute] addAttributeWithKey:[NGDocumentConstant BLIP_ID] andValue:newBlipName]]
										 elementEnd]
										 elementEnd]
										 build];
	
	NGMutateDocument *newBlipOp = [[[[[[[[NGDocOpBuilder builder]
								   elementStart:[NGDocumentConstant CONTRIBUTOR] withAttributes:[[NGDocAttributes emptyAttribute] addAttributeWithKey:[NGDocumentConstant CONTRIBUTOR_NAME] andValue:[_participantId participantIdAtDomain]]]
								   elementEnd]
								   elementStart:[NGDocumentConstant BODY] withAttributes:[NGDocAttributes emptyAttribute]]
								   elementStart:[NGDocumentConstant LINE] withAttributes:[NGDocAttributes emptyAttribute]]
								   elementEnd]
								   elementEnd]
								   build];
	
	NGWaveletDelta *newWaveletDelta = [[[[[NGWaveletDeltaBuilder builder:_participantId] addParticipantOp:_participantId] docOp:[_idGenerator manifestDocumentId] andMutateDocument:newConversation] docOp:newBlipName andMutateDocument:newBlipOp] build];
	
	NGRpcMessage *message = [NGRpcMessage submitRequest:newWaveName waveletDelta:newWaveletDelta hashedVersion:[NGHashedVersion hashedVersion:newWaveName] seqNo:0];
	ProtocolSubmitRequest *request = (ProtocolSubmitRequest *)[message message];
	NGClientRpcController *openInboxController = [[NGClientRpcController alloc] init];
	NGClientRpcCallback *openInboxCallback = [[NGClientRpcCallback alloc] initWithApplication:self];
	[_rpc submit:openInboxController request:request callback:openInboxCallback];
}

- (IBAction) openWave:(id)sender {
	if (_hasWaveOpened) {
		[self closeWave:nil];
	}
	
	NSInteger rowIndex = [inboxTableView clickedRow];
	NGWaveId *waveId = [[inboxViewDelegate getWaveIdByRowIndex:rowIndex] retain];
	_hasWaveOpened = YES;
	
	[self.waveTextView openWithNetwork:_rpc WaveId:[NGWaveId waveIdWithDomain:[waveId domain] waveId:[waveId waveId]] waveletId:[NGWaveletId waveletIdWithDomain:[waveId domain] waveletId:@"conv+root"] participantId:_participantId sequenceNo:0];
	[self.currentWave setStringValue:[self.waveTextView openWaveId]];
	
	NGRpcMessage *message = [NGRpcMessage openRequest:waveId participantId:_participantId seqNo:0];
	ProtocolOpenRequest *request = (ProtocolOpenRequest *)[message message];
	NGClientRpcController *openInboxController = [[NGClientRpcController alloc] init];
	NGClientRpcCallback *openInboxCallback = [[NGClientRpcCallback alloc] initWithApplication:self];
	[_rpc open:openInboxController request:request callback:openInboxCallback];
}

- (IBAction) closeWave:(id)sender {
	if (!_hasWaveOpened) {
		return;
	}
	
	_hasWaveOpened = NO;
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

- (IBAction) addParticipant:(id)sender {
	NGParticipantId *addParticipantId = [NGParticipantId participantIdWithParticipantIdAtDomain:[self.participantAdd stringValue]];
	[self sendWaveletDelta:[[[NGWaveletDeltaBuilder builder:_participantId] addParticipantOp:addParticipantId] build]];
	
	[self.participantAdd setStringValue:@""];
}

- (IBAction) rmParticipant:(id)sender {
	NGParticipantId *rmParticipantId = [NGParticipantId participantIdWithParticipantIdAtDomain:[self.participantList stringValue]];
	[self sendWaveletDelta:[[[NGWaveletDeltaBuilder builder:_participantId] removeParticipantOp:rmParticipantId] build]];
	
	[self.participantList setStringValue:@""];
}

- (IBAction) rmSelf:(id)sender {
	[self sendWaveletDelta:[[[NGWaveletDeltaBuilder builder:_participantId] removeParticipantOp:_participantId] build]];
	
	[self closeWave:nil];
}

- (IBAction) addTag:(id)sender {
	NGDocOpBuilder *docOpBuilder = [NGDocOpBuilder builder];
	if ([self.tagList numberOfItems] != 0) {
		int retainItemCount = 0;
		for (NSString *thisTag in [self.tagList objectValues]) {
			retainItemCount += 2 + [thisTag length];
		}
		docOpBuilder = [docOpBuilder retain:retainItemCount];
	}
	NGMutateDocument *addTagDoc = [[[[docOpBuilder elementStart:[NGDocumentConstant TAG] withAttributes:[NGDocAttributes emptyAttribute]] characters:[self.tagAdd stringValue]] elementEnd] build];
	NGWaveletDelta *waveletDelta = [[[NGWaveletDeltaBuilder builder:_participantId] docOp:[_idGenerator tagDocumentId] andMutateDocument:addTagDoc] build];
	[self sendWaveletDelta:waveletDelta];
	
	[self.tagAdd setStringValue:@""];
}

- (IBAction) rmTag:(id)sender {
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
	
	NGDocOpBuilder *docOpBuilder = [NGDocOpBuilder builder];
	if (retainItemCountBackward != 0) {
		docOpBuilder = [docOpBuilder retain:retainItemCountBackward];
	}
	docOpBuilder = [[[docOpBuilder deleteElementStart:[NGDocumentConstant TAG]] deleteCharacters:tagToBeDeleted] deleteElementEnd];
	if (retainItemCountForward != 0) {
		docOpBuilder = [docOpBuilder retain:retainItemCountForward];
	}
	NGMutateDocument *rmTagDoc = [docOpBuilder build];
	NGWaveletDelta *waveletDelta = [[[NGWaveletDeltaBuilder builder:_participantId] docOp:[_idGenerator tagDocumentId] andMutateDocument:rmTagDoc] build];
	[self sendWaveletDelta:waveletDelta];
	
	[self.tagList setStringValue:@""];
}

- (void)sendWaveletDelta:(NGWaveletDelta *)delta {
	if (!_hasWaveOpened) {
		return;
	}
	
	NGWaveName *waveName = [NGWaveName waveNameWithWaveId:[NGWaveId waveIdWithDomain:_domain waveId:[self.waveTextView openWaveId]] andWaveletId:[_idGenerator newConversationRootWaveletId]];
	NGRpcMessage *message = [NGRpcMessage submitRequest:waveName waveletDelta:delta hashedVersion:[self getHashedVersion] seqNo:0];
	ProtocolSubmitRequest *request = (ProtocolSubmitRequest *)[message message];
	NGClientRpcController *openInboxController = [[NGClientRpcController alloc] init];
	NGClientRpcCallback *openInboxCallback = [[NGClientRpcCallback alloc] initWithApplication:self];
	[_rpc submit:openInboxController request:request callback:openInboxCallback];
}

- (NGHashedVersion *) getHashedVersion {
	return [self.waveTextView hashedVersion];
}

- (void) dealloc {
	[inboxViewDelegate release];
	[_participantId release];
	[_idGenerator release];
	[super dealloc];
}

@end
