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

#import "NGRpc.h"

@implementation NGRpc

- (id) initWithHostName:(NSString *)name port:(NSInteger)port {
	if ((self = [super init])) {
		NSHost *host = [NSHost hostWithName:name];
		[self connectToHost:host port:port];
	}
	return self;
}

- (id) initWithHostAddress:(NSString *)address port:(NSInteger)port {
	if ((self = [super init])) {
		NSHost *host = [NSHost hostWithAddress:address];
		[self connectToHost:host port:port];
	}
	return self;
}

- (id) initWithHost:(NSHost *)host port:(NSInteger)port {
	if ((self = [super init])) {
		[self connectToHost:host port:port];
	}
	return self;
}

- (void) connectToHost:(NSHost *)host port:(NSInteger)port {
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
	
	sequenceNo = 0;
}

- (BOOL) isConnected {
	return (inputStream != nil) && (outputStream != nil) && (pbInputStream != nil) && (pbOutputStream != nil);
}

- (void)send:(PBGeneratedMessage *)message {
	NSMutableString *messageType = [[NSMutableString alloc] initWithString:@"waveserver."];
	[messageType appendString:[message className]];
	int32_t size = computeInt32SizeNoTag(sequenceNo) + computeStringSizeNoTag(messageType) + computeMessageSizeNoTag(message);
	[pbOutputStream writeRawLittleEndian32:size];
	[pbOutputStream writeInt64NoTag:sequenceNo];
	[pbOutputStream writeStringNoTag:messageType];
	[pbOutputStream writeMessageNoTag:message];
	[pbOutputStream flush];
	
	sequenceNo++;
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
	if (eventCode == NSStreamEventHasBytesAvailable) {
		uint8_t buf[1024];
		unsigned int len = 0;
		len = [(NSInputStream *)stream read:buf maxLength:1024];
	}
}

- (void) dealloc {
	[pbInputStream release];
	[pbOutputStream release];
	[inputStream release];
	[outputStream release];
	[super dealloc];
}	

@end
