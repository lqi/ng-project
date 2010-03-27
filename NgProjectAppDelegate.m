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

- (id)init {
	if (self = [super init]) {
		domain = @"192.168.1.5";
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
					NGWaveUrl *waveUrl = [[NGWaveUrl alloc] initWithString:[waveletUpdate waveletName]];
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
									[self.waveTextView apply:[op mutateDocument]];
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
	NSString *waveId = [[inboxViewDelegate getWaveIdByRowIndex:rowIndex] retain];
	hasWaveOpened = YES;
	
	[self.waveTextView openWithWaveId:[NGWaveId waveIdWithDomain:domain waveId:waveId] waveletId:[NGWaveletId waveletIdWithDomain:domain waveletId:@"conv+root"] sequenceNo:_seqNo];
	[self.currentWave setStringValue:[self.waveTextView openWaveId]];
	
	ProtocolOpenRequest_Builder *openRequestBuilder = [ProtocolOpenRequest builder];
	[openRequestBuilder setParticipantId:[participantId participantIdAtDomain]];
	[openRequestBuilder setWaveId:[NSString stringWithFormat:@"%@!%@", domain, waveId]];
	[NGRpc send:[NGRpcMessage rpcMessage:[openRequestBuilder build] sequenceNo:[self getSequenceNo]] viaOutputStream:[network pbOutputStream]];	
	
	[waveId release];
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
	[self.participantList setStringValue:@""];
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
	
	ProtocolOpenRequest_Builder *openRequestBuilder = [ProtocolOpenRequest builder];
	[openRequestBuilder setParticipantId:[participantId participantIdAtDomain]];
	[openRequestBuilder setWaveId:@"indexwave!indexwave"];
	[NGRpc send:[NGRpcMessage rpcMessage:[openRequestBuilder build] sequenceNo:[self getSequenceNo]] viaOutputStream:[network pbOutputStream]];	
}

- (IBAction) newWave:(id)sender {
	if (![network isConnected]) {
		return;
	}
	
	NGWaveUrl *waveUrl = [[NGWaveUrl alloc] initWithWaveId:[idGenerator newWaveId] WaveletId:[idGenerator newConversationRootWaveletId]];
	NSString *waveName = [waveUrl stringValue];
	[waveUrl release];
	NSString *blipName = [idGenerator newDocumentId];
	
	ProtocolSubmitRequest_Builder *submitRequestBuilder = [ProtocolSubmitRequest builder];
	[submitRequestBuilder setWaveletName:waveName];
	
	ProtocolWaveletDelta_Builder *deltaBuilder = [ProtocolWaveletDelta builder];
	[deltaBuilder setAuthor:[participantId participantIdAtDomain]];
	
	// First Operation to add current user as the participant
	ProtocolWaveletOperation_Builder *opAddParticipantBuilder = [ProtocolWaveletOperation builder];
	[opAddParticipantBuilder setAddParticipant:[participantId participantIdAtDomain]];
	[deltaBuilder addOperation:[opAddParticipantBuilder build]];
	
	// Second Operation to create the conversation
	ProtocolDocumentOperation_Component_ElementStart_Builder *conversationElementStartBuilder = [ProtocolDocumentOperation_Component_ElementStart builder];
	[conversationElementStartBuilder setType:@"conversation"];
	ProtocolDocumentOperation_Component_ElementStart_Builder *newBlipElementStartBuilder = [ProtocolDocumentOperation_Component_ElementStart builder];
	[newBlipElementStartBuilder setType:@"blip"];
	ProtocolDocumentOperation_Component_KeyValuePair_Builder *newBlipAttributeBuilder = [ProtocolDocumentOperation_Component_KeyValuePair builder];
	[newBlipAttributeBuilder setKey:@"id"];
	[newBlipAttributeBuilder setValue:blipName];
	[newBlipElementStartBuilder addAttribute:[newBlipAttributeBuilder build]];
	ProtocolDocumentOperation_Builder *docOpBuilder = [ProtocolDocumentOperation builder];
	[docOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementStart:[conversationElementStartBuilder build]] build]];
	[docOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementStart:[newBlipElementStartBuilder build]] build]];
	[docOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementEnd:YES] build]];
	[docOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementEnd:YES] build]];
	ProtocolWaveletOperation_MutateDocument_Builder *mutateDocBuilder = [ProtocolWaveletOperation_MutateDocument builder];
	[mutateDocBuilder setDocumentId:@"conversation"];
	[mutateDocBuilder setDocumentOperation:[docOpBuilder build]];
	ProtocolWaveletOperation_Builder *opCreateConversationBuilder = [ProtocolWaveletOperation builder];
	[opCreateConversationBuilder setMutateDocument:[mutateDocBuilder build]];
	[deltaBuilder addOperation:[opCreateConversationBuilder build]];
	
	// Third Operation to add a new document in the conversation
	ProtocolDocumentOperation_Component_ElementStart_Builder *blipContributorElementStartBuilder = [ProtocolDocumentOperation_Component_ElementStart builder];
	[blipContributorElementStartBuilder setType:@"contributor"];
	ProtocolDocumentOperation_Component_KeyValuePair_Builder *contributorAttributeBuilder = [ProtocolDocumentOperation_Component_KeyValuePair builder];
	[contributorAttributeBuilder setKey:@"name"];
	[contributorAttributeBuilder setValue:[participantId participantIdAtDomain]];
	[blipContributorElementStartBuilder addAttribute:[contributorAttributeBuilder build]];
	ProtocolDocumentOperation_Component_ElementStart_Builder *blipBodyElementStartBuilder = [ProtocolDocumentOperation_Component_ElementStart builder];
	[blipBodyElementStartBuilder setType:@"body"];
	ProtocolDocumentOperation_Component_ElementStart_Builder *blipLineElementStartBuilder = [ProtocolDocumentOperation_Component_ElementStart builder];
	[blipLineElementStartBuilder setType:@"line"];
	ProtocolDocumentOperation_Builder *blipDocOpBuilder = [ProtocolDocumentOperation builder];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementStart:[blipContributorElementStartBuilder build]] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementEnd:YES] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementStart:[blipBodyElementStartBuilder build]] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementStart:[blipLineElementStartBuilder build]] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementEnd:YES] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementEnd:YES] build]];
	ProtocolWaveletOperation_MutateDocument_Builder *blipMutateDocBuilder = [ProtocolWaveletOperation_MutateDocument builder];
	[blipMutateDocBuilder setDocumentId:blipName];
	[blipMutateDocBuilder setDocumentOperation:[blipDocOpBuilder build]];
	ProtocolWaveletOperation_Builder *blipOpCreateConversationBuilder = [ProtocolWaveletOperation builder];
	[blipOpCreateConversationBuilder setMutateDocument:[blipMutateDocBuilder build]];
	[deltaBuilder addOperation:[blipOpCreateConversationBuilder build]];
	
	ProtocolHashedVersion_Builder *hashedVersionBuilder = [ProtocolHashedVersion builder];
	[hashedVersionBuilder setVersion:0];
	[hashedVersionBuilder setHistoryHash:[waveName dataUsingEncoding:NSUTF8StringEncoding]];
	[deltaBuilder setHashedVersion:[hashedVersionBuilder build]];
	
	[submitRequestBuilder setDelta:[deltaBuilder build]];
	
	[NGRpc send:[NGRpcMessage rpcMessage:[submitRequestBuilder build] sequenceNo:[self getSequenceNo]] viaOutputStream:[network pbOutputStream]];	
}

- (IBAction) addParticipant:(id)sender {
	if (![network isConnected] || !hasWaveOpened) {
		return;
	}
	
	NGWaveUrl *waveUrl = [[NGWaveUrl alloc] initWithWaveId:[NGWaveId waveIdWithDomain:domain waveId:[self.waveTextView openWaveId]] WaveletId:[idGenerator newConversationRootWaveletId]];
	NSString *waveName = [waveUrl stringValue];
	[waveUrl release];
	
	ProtocolSubmitRequest_Builder *submitRequestBuilder = [ProtocolSubmitRequest builder];
	[submitRequestBuilder setWaveletName:waveName];
	
	ProtocolWaveletDelta_Builder *deltaBuilder = [ProtocolWaveletDelta builder];
	[deltaBuilder setAuthor:[participantId participantIdAtDomain]];
	
	ProtocolWaveletOperation_Builder *opAddParticipantBuilder = [ProtocolWaveletOperation builder];
	NGParticipantId *addParticipantId = [NGParticipantId participantIdWithParticipantIdAtDomain:[self.participantAdd stringValue]];
	[opAddParticipantBuilder setAddParticipant:[addParticipantId participantIdAtDomain]];
	[deltaBuilder addOperation:[opAddParticipantBuilder build]];
	
	ProtocolHashedVersion_Builder *hashedVersionBuilder = [ProtocolHashedVersion builder];
	[hashedVersionBuilder setVersion:self.waveTextView.waveletVersion];
	[hashedVersionBuilder setHistoryHash:self.waveTextView.waveletHistoryHash];
	[deltaBuilder setHashedVersion:[hashedVersionBuilder build]];
	
	[submitRequestBuilder setDelta:[deltaBuilder build]];
	
	[NGRpc send:[NGRpcMessage rpcMessage:[submitRequestBuilder build] sequenceNo:[self getSequenceNo]] viaOutputStream:[network pbOutputStream]];
	
	[self.participantAdd setStringValue:@""];
}

- (IBAction) rmParticipant:(id)sender {
	if (![network isConnected] || !hasWaveOpened) {
		return;
	}
	
	NGWaveUrl *waveUrl = [[NGWaveUrl alloc] initWithWaveId:[NGWaveId waveIdWithDomain:domain waveId:[self.waveTextView openWaveId]] WaveletId:[idGenerator newConversationRootWaveletId]];
	NSString *waveName = [waveUrl stringValue];
	[waveUrl release];
	
	ProtocolSubmitRequest_Builder *submitRequestBuilder = [ProtocolSubmitRequest builder];
	[submitRequestBuilder setWaveletName:waveName];
	
	ProtocolWaveletDelta_Builder *deltaBuilder = [ProtocolWaveletDelta builder];
	[deltaBuilder setAuthor:[participantId participantIdAtDomain]];
	
	ProtocolWaveletOperation_Builder *opRemoveParticipantBuilder = [ProtocolWaveletOperation builder];
	NGParticipantId *rmParticipantId = [NGParticipantId participantIdWithParticipantIdAtDomain:[self.participantList stringValue]];
	[opRemoveParticipantBuilder setRemoveParticipant:[rmParticipantId participantIdAtDomain]];
	[deltaBuilder addOperation:[opRemoveParticipantBuilder build]];
	
	ProtocolHashedVersion_Builder *hashedVersionBuilder = [ProtocolHashedVersion builder];
	[hashedVersionBuilder setVersion:self.waveTextView.waveletVersion];
	[hashedVersionBuilder setHistoryHash:self.waveTextView.waveletHistoryHash];
	[deltaBuilder setHashedVersion:[hashedVersionBuilder build]];
	
	[submitRequestBuilder setDelta:[deltaBuilder build]];
	
	[NGRpc send:[NGRpcMessage rpcMessage:[submitRequestBuilder build] sequenceNo:[self getSequenceNo]] viaOutputStream:[network pbOutputStream]];
	
	[self.participantList setStringValue:@""];
}

- (IBAction) rmSelf:(id)sender {
	if (![network isConnected] || !hasWaveOpened) {
		return;
	}
	
	NGWaveUrl *waveUrl = [[NGWaveUrl alloc] initWithWaveId:[NGWaveId waveIdWithDomain:domain waveId:[self.waveTextView openWaveId]] WaveletId:[idGenerator newConversationRootWaveletId]];
	NSString *waveName = [waveUrl stringValue];
	[waveUrl release];
	
	ProtocolSubmitRequest_Builder *submitRequestBuilder = [ProtocolSubmitRequest builder];
	[submitRequestBuilder setWaveletName:waveName];
	
	ProtocolWaveletDelta_Builder *deltaBuilder = [ProtocolWaveletDelta builder];
	[deltaBuilder setAuthor:[participantId participantIdAtDomain]];
	
	ProtocolWaveletOperation_Builder *opRemoveParticipantBuilder = [ProtocolWaveletOperation builder];
	[opRemoveParticipantBuilder setRemoveParticipant:[participantId participantIdAtDomain]];
	[deltaBuilder addOperation:[opRemoveParticipantBuilder build]];
	
	ProtocolHashedVersion_Builder *hashedVersionBuilder = [ProtocolHashedVersion builder];
	[hashedVersionBuilder setVersion:self.waveTextView.waveletVersion];
	[hashedVersionBuilder setHistoryHash:self.waveTextView.waveletHistoryHash];
	[deltaBuilder setHashedVersion:[hashedVersionBuilder build]];
	
	[submitRequestBuilder setDelta:[deltaBuilder build]];
	
	[NGRpc send:[NGRpcMessage rpcMessage:[submitRequestBuilder build] sequenceNo:[self getSequenceNo]] viaOutputStream:[network pbOutputStream]];
	
	[self closeWave:nil];
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
