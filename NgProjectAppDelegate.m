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

- (id)init {
	if (self = [super init]) {
		domain = @"192.168.131.5";
		participantId = [[NGParticipantId alloc] initWithDomain:domain participantId:@"test"];
		seqNo = 0;
		idGenerator = [[NGRandomIdGenerator alloc] initWithDomain:domain];
		inboxViewDelegate = [[NGInboxViewDelegate alloc] init];
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
					else if (hasWaveOpened && [updateWaveId isEqual:openedWaveId]) {
						int waveletVersion = [[waveletUpdate resultingVersion] version];
						NSData *waveletHistoryHash = [[waveletUpdate resultingVersion] historyHash];
						[versionInfo setStringValue:[NSString stringWithFormat:@"%d, %@", waveletVersion, [waveletHistoryHash description]]];
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
	
	NSInteger rowIndex = [inboxTableView clickedRow];
	NSString *waveId = [[inboxViewDelegate getWaveIdByRowIndex:rowIndex] retain];
	openedWaveId = waveId;
	hasWaveOpened = YES;
	[self.currentWave setStringValue:openedWaveId];
	
	ProtocolOpenRequest_Builder *openRequestBuilder = [ProtocolOpenRequest builder];
	[openRequestBuilder setParticipantId:[participantId participantIdAtDomain]];
	[openRequestBuilder setWaveId:[NSString stringWithFormat:@"%@!%@", domain, waveId]];
	[NGRpc send:[NGRpcMessage rpcMessage:[openRequestBuilder build] sequenceNo:seqNo++] viaOutputStream:[network pbOutputStream]];	
	
	[waveId release];
}

- (IBAction) closeWave:(id)sender {
	hasWaveOpened = NO;
	[self.currentWave setStringValue:@"No open wave, double-click wave in the inbox"];
	[self.versionInfo setStringValue:@""];
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
	[NGRpc send:[NGRpcMessage rpcMessage:[openRequestBuilder build] sequenceNo:seqNo++] viaOutputStream:[network pbOutputStream]];	
}

- (IBAction) newWave:(id)sender {
	if (![network isConnected]) {
		return;
	}
	
	NGWaveUrl *waveUrl = [[NGWaveUrl alloc] initWithWaveId:[idGenerator newWaveId] WaveletId:[idGenerator newConversationRootWaveletId]];
	NSString *waveName = [waveUrl stringValue];
	[waveUrl release];
	
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
	ProtocolDocumentOperation_Builder *docOpBuilder = [ProtocolDocumentOperation builder];
	[docOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementStart:[conversationElementStartBuilder build]] build]];
	[docOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementEnd:YES] build]];
	ProtocolWaveletOperation_MutateDocument_Builder *mutateDocBuilder = [ProtocolWaveletOperation_MutateDocument builder];
	[mutateDocBuilder setDocumentId:@"conversation"];
	[mutateDocBuilder setDocumentOperation:[docOpBuilder build]];
	ProtocolWaveletOperation_Builder *opCreateConversationBuilder = [ProtocolWaveletOperation builder];
	[opCreateConversationBuilder setMutateDocument:[mutateDocBuilder build]];
	[deltaBuilder addOperation:[opCreateConversationBuilder build]];
	
	ProtocolHashedVersion_Builder *hashedVersionBuilder = [ProtocolHashedVersion builder];
	[hashedVersionBuilder setVersion:0];
	[hashedVersionBuilder setHistoryHash:[waveName dataUsingEncoding:NSUTF8StringEncoding]];
	[deltaBuilder setHashedVersion:[hashedVersionBuilder build]];
	
	[submitRequestBuilder setDelta:[deltaBuilder build]];
	
	[NGRpc send:[NGRpcMessage rpcMessage:[submitRequestBuilder build] sequenceNo:seqNo++] viaOutputStream:[network pbOutputStream]];	
}

- (void) dealloc {
	[inboxViewDelegate release];
	[participantId release];
	[idGenerator release];
	[network release];
	[super dealloc];
}

@end
