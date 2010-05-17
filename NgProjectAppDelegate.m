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
		
		_host = [[NGHost alloc] initWithDomain:_domain andPort:9876];
		
		_channel = [[NGClientRpcChannel alloc] initWithHost:_host];
		
		_rpc = [[NGClientRpc alloc] initWithChannel:_channel];
		
		_controllerMap = [[NSMutableArray alloc] init];
		
		[NSThread detachNewThreadSelector:@selector(connectionStatueControllerThread) toTarget:self withObject:nil];
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

- (void) connectionStatueControllerThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	while (YES) {
		[NSThread sleepForTimeInterval:0.5];
		[self connectionStatueController];
	}
	
	[pool release];
}

- (void) connectionStatueController {
	[self.statusLabel setStringValue:([_channel isConnected] ? @"Online": @"Offline")];
}

- (void) rpcCallbackUpdateHashedVersion:(NGHashedVersion *)hashedVersion forWavelet:(NGWaveletName *)waveName {
	NSString *updateWaveId = [[waveName waveId] waveId];
	if ([updateWaveId isEqual:@"indexwave!indexwave"]) {
		// ignore, as indexwave at the moment doesn't care version
	}
	else if (_hasWaveOpened && [updateWaveId isEqual:[self.waveTextView openWaveId]]) {
		[self.waveTextView setHashedVersion:hashedVersion.version withHistoryHash:hashedVersion.historyHash];
		[versionInfo setStringValue:[[self.waveTextView hashedVersion] stringValue]];
	}
}

- (void) rpcCallbackAddParticipant:(NGParticipantId *)participantId fromAuthor:(NGParticipantId *)author forWavelet:(NGWaveletName *)waveName {
	NSString *updateWaveId = [[waveName waveId] waveId];
	if ([updateWaveId isEqual:@"indexwave!indexwave"]) {
		[inboxViewDelegate addParticipant:participantId fromAuthor:author forWavelet:waveName];
		[inboxTableView reloadData];
	}
	else if (_hasWaveOpened && [updateWaveId isEqual:[self.waveTextView openWaveId]]) {
		[participantList addItemWithObjectValue:[participantId participantIdAtDomain]];
	}
}

- (void) rpcCallbackRemoveParticipant:(NGParticipantId *)participantId fromAuthor:(NGParticipantId *)author forWavelet:(NGWaveletName *)waveName {
	NSString *updateWaveId = [[waveName waveId] waveId];
	if ([updateWaveId isEqual:@"indexwave!indexwave"]) {
		[inboxViewDelegate removeParticipant:participantId fromAuthor:author forWavelet:waveName];
		[inboxTableView reloadData];
	}
	else if (_hasWaveOpened && [updateWaveId isEqual:[self.waveTextView openWaveId]]) {
		[participantList removeItemWithObjectValue:[participantId participantIdAtDomain]];
	}
}

- (void) rpcCallbackWaveletDocument:(ProtocolWaveletOperation_MutateDocument *)document fromAuthor:(NGParticipantId *)author forWavelet:(NGWaveletName *)waveName {
	NSString *updateWaveId = [[waveName waveId] waveId];
	if ([updateWaveId isEqual:@"indexwave!indexwave"]) {
		[inboxViewDelegate waveletDocument:document fromAuthor:author forWavelet:waveName];
		[inboxTableView reloadData];
	}
	else if (_hasWaveOpened && [updateWaveId isEqual:[self.waveTextView openWaveId]]) {
		if ([[document documentId] isEqual:@"tags"]) {
			for (ProtocolDocumentOperation_Component *comp in [[document documentOperation] componentList]) {
				if ([comp hasCharacters]) {
					[tagList addItemWithObjectValue:[comp characters]];
				}
				if ([comp hasDeleteCharacters]) {
					[tagList removeItemWithObjectValue:[comp deleteCharacters]];
				}
			}
		}
		else {
			[self.waveTextView apply:document];
		}
	}
}

- (void) rpcCallbackNoOperationFromAuthor:(NGParticipantId *)author forWavelet:(NGWaveletName *)waveName {
	NSString *updateWaveId = [[waveName waveId] waveId];
	if ([updateWaveId isEqual:@"indexwave!indexwave"]) {
		// ignore, as indexwave at the moment doesn't care no operation
	}
	else if (_hasWaveOpened && [updateWaveId isEqual:[self.waveTextView openWaveId]]) {
		NSLog(@"receive a no operation in NgProjectAppDelegate from author: %@", [author participantIdAtDomain]);
	}
}

- (void) rpcCallbackSubmitResponse {
	NSLog(@"receive a submit response in NgProjectAppDelegate");
}

- (void) rpcCallbackFailure:(NSString *)errorText {
	NSLog(@"RPC Failed in NgProjectAppDelegate: %@", errorText);
}

- (void) rpcCallbackUnknownMessage:(NSString *)messageType message:(PBGeneratedMessage *)message {
	NSLog(@"RPC Unknown Message in NgProjectAppDelegate: %@", messageType);
}

- (void) openInbox {
	NGClientRpcController *openInboxController = [NGClientRpcController rpcController];
	[_controllerMap addObject:openInboxController];
	
	ProtocolOpenRequest_Builder *openInboxRequestBuilder = [ProtocolOpenRequest builder];
	[openInboxRequestBuilder setParticipantId:[_participantId participantIdAtDomain]];
	[openInboxRequestBuilder setWaveId:[[_idGenerator indexWaveId] waveIdFollowedByDomain]];
	[openInboxRequestBuilder setSnapshots:NO];
	
	NGClientRpcCallback *openInboxCallback = [[NGClientRpcCallback alloc] initWithApplication:self];
	
	[_rpc open:openInboxController request:[openInboxRequestBuilder build] callback:openInboxCallback];
}

- (IBAction) newWave:(id)sender {
	
	NGWaveletName *newWaveName = [NGWaveletName waveNameWithWaveId:[_idGenerator newWaveId] andWaveletId:[_idGenerator newConversationRootWaveletId]];
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
	
	NGClientRpcController *controller = [NGClientRpcController rpcController];
	[_controllerMap addObject:controller];
	NGClientRpcCallback *callback = [[NGClientRpcCallback alloc] initWithApplication:self];
	[_rpc submitRequest:controller waveName:newWaveName waveletDelta:newWaveletDelta hashedVersion:[NGHashedVersion hashedVersion:newWaveName] callback:callback];
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
	
	NGClientRpcController *controller = [NGClientRpcController rpcController];
	[_controllerMap addObject:controller];
	NGClientRpcCallback *openWaveCallback = [[NGClientRpcCallback alloc] initWithApplication:self];
	[_rpc openRequest:controller waveId:waveId participantId:_participantId snapshot:YES callback:openWaveCallback];
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

- (IBAction) shutdown:(id)sender {
	NSLog(@"shutdown!");
	for (NGClientRpcController *controller in _controllerMap) {
		[controller startCancel];
	}
	exit(0);
}

- (void)sendWaveletDelta:(NGWaveletDelta *)delta {
	if (!_hasWaveOpened) {
		return;
	}
	
	NGWaveletName *waveName = [NGWaveletName waveNameWithWaveId:[NGWaveId waveIdWithDomain:_domain waveId:[self.waveTextView openWaveId]] andWaveletId:[_idGenerator newConversationRootWaveletId]];
	NGClientRpcController *controller = [NGClientRpcController rpcController];
	[_controllerMap addObject:controller];
	NGClientRpcCallback *callback = [[NGClientRpcCallback alloc] initWithApplication:self];
	[_rpc submitRequest:controller waveName:waveName waveletDelta:delta hashedVersion:[self getHashedVersion] callback:callback];
}

- (NGHashedVersion *) getHashedVersion {
	return [self.waveTextView hashedVersion];
}

- (void) dealloc {
	[inboxViewDelegate release];
	[_participantId release];
	[_idGenerator release];
	[_host release];
	[_channel release];
	[_rpc release];
	[_controllerMap release];
	[super dealloc];
}

@end
