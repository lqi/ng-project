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
		
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	network = [[NGNetwork alloc] initWithHostAddress:@"192.168.1.5" port:9876];
}

- (IBAction) goReceive:(id)sender {
	if (![network isConnected]) {
		return;
	}
	
	[NGRpc receive:[network pbInputStream]];
}

- (IBAction) goNewSock:(id)sender {
	if (![network isConnected]) {
		return;
	}
	
	/*
	 open
	 */
	ProtocolOpenRequest_Builder *openRequestBuilder = [ProtocolOpenRequest builder];
	[openRequestBuilder setParticipantId:@"test@192.168.1.5"];
	[openRequestBuilder setWaveId:@"indexwave!indexwave"];
	[NGRpc send:[openRequestBuilder build] viaOutputStream:[network pbOutputStream] sequenceNo:1];
	
	/*
	 new wave
	 */
	NSString *waveName = @"wave://192.168.1.5/w+PkFExyYKI2P/conv+root";
	
	ProtocolSubmitRequest_Builder *submitRequestBuilder = [ProtocolSubmitRequest builder];
	[submitRequestBuilder setWaveletName:waveName];
	
	ProtocolWaveletDelta_Builder *deltaBuilder = [ProtocolWaveletDelta builder];
	[deltaBuilder setAuthor:@"test@192.168.1.5"];
	
	ProtocolWaveletOperation_Builder *opBuilder;
	opBuilder = [ProtocolWaveletOperation builder];
	[opBuilder setAddParticipant:@"test@192.168.1.5"];
	[deltaBuilder addOperation:[opBuilder build]];
	[opBuilder release];
	
	ProtocolHashedVersion_Builder *hashedVersionBuilder = [ProtocolHashedVersion builder];
	[hashedVersionBuilder setVersion:0];
	[hashedVersionBuilder setHistoryHash:[waveName dataUsingEncoding:NSUTF8StringEncoding]];
	[deltaBuilder setHashedVersion:[hashedVersionBuilder build]];
	
	[submitRequestBuilder setDelta:[deltaBuilder build]];
	
	[NGRpc send:[submitRequestBuilder build] viaOutputStream:[network pbOutputStream] sequenceNo:2];
	
}

- (void) dealloc {
	[network release];
	[super dealloc];
}

@end
