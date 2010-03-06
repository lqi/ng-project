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

- (id)init {
	if (self = [super init]) {
		domain = @"192.168.1.5";
		seqNo = 0;
		idGenerator = [[NGRandomIdGenerator alloc] initWithDomain:domain];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	network = [[NGNetwork alloc] initWithHostAddress:domain port:9876];
}

- (IBAction) goReceive:(id)sender {
	if (![network isConnected]) {
		return;
	}
	
	[NGRpc receive:[network pbInputStream]];
}

- (IBAction) openIndex:(id)sender {
	if (![network isConnected]) {
		return;
	}
	
	ProtocolOpenRequest_Builder *openRequestBuilder = [ProtocolOpenRequest builder];
	[openRequestBuilder setParticipantId:@"test@192.168.1.5"];
	[openRequestBuilder setWaveId:@"indexwave!indexwave"];
	[NGRpc send:[openRequestBuilder build] viaOutputStream:[network pbOutputStream] sequenceNo:seqNo++];
	
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
	[deltaBuilder setAuthor:@"test@192.168.1.5"];
	
	ProtocolWaveletOperation_Builder *opBuilder = [ProtocolWaveletOperation builder];
	[opBuilder setAddParticipant:@"test@192.168.1.5"];
	[deltaBuilder addOperation:[opBuilder build]];
	
	ProtocolHashedVersion_Builder *hashedVersionBuilder = [ProtocolHashedVersion builder];
	[hashedVersionBuilder setVersion:0];
	[hashedVersionBuilder setHistoryHash:[waveName dataUsingEncoding:NSUTF8StringEncoding]];
	[deltaBuilder setHashedVersion:[hashedVersionBuilder build]];
	
	[submitRequestBuilder setDelta:[deltaBuilder build]];
	
	[NGRpc send:[submitRequestBuilder build] viaOutputStream:[network pbOutputStream] sequenceNo:seqNo++];
}

- (void) dealloc {
	[idGenerator release];
	[network release];
	[super dealloc];
}

@end
