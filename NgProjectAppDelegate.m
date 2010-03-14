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

- (id)init {
	if (self = [super init]) {
		domain = @"192.168.131.5";
		userName = @"test";
		seqNo = 0;
		idGenerator = [[NGRandomIdGenerator alloc] initWithDomain:domain];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	network = [[NGNetwork alloc] initWithHostDomain:domain port:9876];
	
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(openInbox) userInfo:nil repeats:NO];
	
	[NSThread detachNewThreadSelector:@selector(connectionStatueControllerThread) toTarget:self withObject:nil];
	[NSThread detachNewThreadSelector:@selector(newReceiveThread) toTarget:self withObject:nil];
}

- (void) newReceiveThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	while (YES) {
		[NSThread sleepForTimeInterval:0.5];
		NSLog(@"receive");
		[self newReceive];
	}
	
	[pool release];
}

- (void) newReceive {
	if ([network isConnected]) {
		if ([network callbackAvailable]) {
			while (![[network pbInputStream] isAtEnd]) {
				NGRpcMessage *msg = [NGRpc receive:[network pbInputStream]];
				NSLog([NSString stringWithFormat:@"%d: %@", [msg sequenceNo], [[msg message] className]]);
			}
		}
	}
}

- (void) connectionStatueControllerThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	while (YES) {
		[NSThread sleepForTimeInterval:0.5];
		NSLog(@"status");
		[self connectionStatueController];
	}
	
	[pool release];
}

- (void) connectionStatueController {
	[self.statusLabel setStringValue:([network isConnected] ? @"Online": @"Offline")];
}

- (IBAction) goReceive:(id)sender {
	if (![network isConnected]) {
		return;
	}
	
	[NGRpc receive:[network pbInputStream]];
}

- (void) openInbox {
	NSLog(@"open inbox");
	if (![network isConnected]) {
		return;
	}
	
	ProtocolOpenRequest_Builder *openRequestBuilder = [ProtocolOpenRequest builder];
	[openRequestBuilder setParticipantId:[NSString stringWithFormat:@"%@@%@", userName, domain]];
	[openRequestBuilder setWaveId:@"indexwave!indexwave"];
	[NGRpc send:[NGRpcMessage rpcMessage:[openRequestBuilder build] sequenceNo:seqNo++] viaOutputStream:[network pbOutputStream]];	
}

- (IBAction) newWave:(id)sender {
	if (![network isConnected]) {
		return;
	}
	
	NSMutableString *waveName = [[NSMutableString alloc] initWithString:@"wave://"];
	[waveName appendString:domain];
	[waveName appendString:@"/"];
	[waveName appendString:[[idGenerator newWaveId] waveId]];
	[waveName appendString:@"/"];
	[waveName appendString:[[idGenerator newConversationRootWaveletId] waveletId]];
	
	ProtocolSubmitRequest_Builder *submitRequestBuilder = [ProtocolSubmitRequest builder];
	[submitRequestBuilder setWaveletName:waveName];
	
	ProtocolWaveletDelta_Builder *deltaBuilder = [ProtocolWaveletDelta builder];
	[deltaBuilder setAuthor:[NSString stringWithFormat:@"%@@%@", userName, domain]];
	
	ProtocolWaveletOperation_Builder *opBuilder = [ProtocolWaveletOperation builder];
	[opBuilder setAddParticipant:[NSString stringWithFormat:@"%@@%@", userName, domain]];
	[deltaBuilder addOperation:[opBuilder build]];
	
	ProtocolHashedVersion_Builder *hashedVersionBuilder = [ProtocolHashedVersion builder];
	[hashedVersionBuilder setVersion:0];
	[hashedVersionBuilder setHistoryHash:[waveName dataUsingEncoding:NSUTF8StringEncoding]];
	[deltaBuilder setHashedVersion:[hashedVersionBuilder build]];
	
	[submitRequestBuilder setDelta:[deltaBuilder build]];
	
	[NGRpc send:[NGRpcMessage rpcMessage:[submitRequestBuilder build] sequenceNo:seqNo++] viaOutputStream:[network pbOutputStream]];	
}

- (void) dealloc {
	[idGenerator release];
	[network release];
	[super dealloc];
}

@end
