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

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
	switch(eventCode) {
        case NSStreamEventHasBytesAvailable: 
		{
			uint8_t buf[1024];
			
            unsigned int len = 0;
			
            len = [(NSInputStream *)stream read:buf maxLength:1024];
			
            NSLog([NSString stringWithFormat:@"%d", len]);
		}
	}
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSLog(@"Ready");
	
	NSHost *host = [NSHost hostWithAddress:@"192.168.1.5"];
	//NSHost *host = [NSHost hostWithName:@"sandbox.ng.longyiqi.com"];
	[NSStream getStreamsToHost:host port:9876 inputStream:&inputStream outputStream:&outputStream];
	[inputStream retain];
	[outputStream retain];
	[inputStream setDelegate:self];
	[outputStream setDelegate:self];
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	pbOutputStream = [PBCodedOutputStream streamWithOutputStream:outputStream];
	[pbOutputStream retain];
	
	pbInputStream = [PBCodedInputStream streamWithInputStream:inputStream];
	[pbInputStream retain];
	
	NSLog(@"Connected!");
	
}

- (void)sendMessage:(PBGeneratedMessage *)message withSequence:(long)sequenceNo {
	NSMutableString *messageType = [[NSMutableString alloc] initWithString:@"waveserver."];
	[messageType appendString:[message className]];
	int32_t size = computeInt32SizeNoTag(sequenceNo) + computeStringSizeNoTag(messageType) + computeMessageSizeNoTag(message);
	[pbOutputStream writeRawLittleEndian32:size];
	[pbOutputStream writeInt64NoTag:sequenceNo];
	[pbOutputStream writeStringNoTag:messageType];
	[pbOutputStream writeMessageNoTag:message];
	[pbOutputStream flush];
}

- (IBAction) goNewSock:(id)sender {
	NSLog(@"New Sock Respond!");
	
	/*
	 open
	 */
	ProtocolOpenRequest_Builder *openRequestBuilder = [ProtocolOpenRequest builder];
	[openRequestBuilder setParticipantId:@"test@192.168.1.5"];
	[openRequestBuilder setWaveId:@"indexwave!indexwave"];
	[self sendMessage:[openRequestBuilder build] withSequence:1];
	
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
	
	[self sendMessage:[submitRequestBuilder build] withSequence:2];
	
}

@end
