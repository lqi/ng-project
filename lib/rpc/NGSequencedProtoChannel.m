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

#import "NGSequencedProtoChannel.h"

@interface NGSequencedProtoChannel()

- (void) getStreamsToHostName:(NSString *)domain port:(NSInteger)port inputStream:(NSInputStream **)inputStreamPtr outputStream:(NSOutputStream **)outputStreamPtr;
- (void) connectToHost:(NSString *)domain port:(NSInteger)port;

@end

@implementation NGSequencedProtoChannel

@synthesize host;
@synthesize callback;

- (void) getStreamsToHostName:(NSString *)domain port:(NSInteger)port inputStream:(NSInputStream **)inputStreamPtr outputStream:(NSOutputStream **)outputStreamPtr {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
	
    assert(domain != nil);
    assert((port > 0) && (port < 65536));
    assert((inputStreamPtr != NULL) || (outputStreamPtr != NULL));
	
    readStream = NULL;
    writeStream = NULL;
	
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef) domain, port, ((inputStreamPtr != nil) ? &readStream : NULL), ((outputStreamPtr != nil) ? &writeStream : NULL));
	
    if (inputStreamPtr != NULL) {
        *inputStreamPtr = [NSMakeCollectable(readStream) autorelease];
    }
    if (outputStreamPtr != NULL) {
        *outputStreamPtr = [NSMakeCollectable(writeStream) autorelease];
    }
}

- (void) connectToHost:(NSString *)domain port:(NSInteger)port {
	[self getStreamsToHostName:domain port:port inputStream:&_inputStream outputStream:&_outputStream];
	[_inputStream retain];
	[_outputStream retain];
	
	_pbOutputStream = [PBCodedOutputStream streamWithOutputStream:_outputStream];
	[_pbOutputStream retain];
	
	_pbInputStream = [PBCodedInputStream streamWithInputStream:_inputStream];
	[_pbInputStream retain];
}

- (id) initWithHost:(NGHost *)aHost callback:(NGProtoCallback *)aCallback {
	if (self = [super init]) {
		_expectedMessages = [[NSMutableDictionary alloc] init];
		self.host = aHost;
		self.callback = aCallback;
		[self connectToHost:[self.host domain] port:[self.host port]];
	}
	return self;
}

- (void) expectMessage:(PBGeneratedMessage *)messagePrototype {
	[_expectedMessages setValue:messagePrototype forKey:[[messagePrototype class] description]];
}

- (PBGeneratedMessage *) getMessagePrototype:(NSString *)messageType {
	return [_expectedMessages valueForKey:messageType];
}

- (void) sendMessage:(long)sequenceNo message:(PBGeneratedMessage *)message withExpectedResponsePrototype:(PBGeneratedMessage *)expectedPrototype {
	[self expectMessage:expectedPrototype];
	[self sendMessage:sequenceNo message:message];
}

- (void) sendMessage:(long)sequenceNo message:(PBGeneratedMessage *)message {
	NSMutableString *messageType = [[NSMutableString alloc] initWithString:@"waveserver."];
	[messageType appendString:[[message class] description]];
	int32_t size = computeInt32SizeNoTag(sequenceNo) + computeStringSizeNoTag(messageType) + computeMessageSizeNoTag(message);
	@synchronized (_pbOutputStream) {
		[_pbOutputStream writeRawLittleEndian32:size];
		[_pbOutputStream writeInt64NoTag:sequenceNo];
		[_pbOutputStream writeStringNoTag:messageType];
		[_pbOutputStream writeMessageNoTag:message];
		[_pbOutputStream flush];
	}
}

- (void) receiveMessage {
	@synchronized (_pbInputStream) {
		/* int32_t size = */[_pbInputStream readRawLittleEndian32];
		long sequenceNo = [_pbInputStream readInt64];
		NSMutableString *messageType = [[NSMutableString alloc] initWithString:[_pbInputStream readString]];
		NSString *stringToBeDeleted = @"waveserver.";
		NSRange rangeToBeDeleted = {0, [stringToBeDeleted length]};
		[messageType deleteCharactersInRange:rangeToBeDeleted];
		PBGeneratedMessage *prototype = [self getMessagePrototype:messageType];
		if (prototype == nil) {
			int length = [_pbInputStream readRawVarint32];
			/* int oldLimit = */[_pbInputStream pushLimit:length];
			[_pbInputStream popLimit:length];
			[self.callback unknown:sequenceNo messageType:messageType];
		}
		else {
			PBGeneratedMessage_Builder *messageBuilder = [prototype builder];
			[_pbInputStream readMessage:messageBuilder extensionRegistry:[PBExtensionRegistry emptyRegistry]];
			[self.callback message:sequenceNo message:[messageBuilder build]];
		}
	}
}

- (void) receiveMessageThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	while (YES) {
		[self receiveMessage];
	}
	[pool release];
}

- (void) startAsyncRead {
	[NSThread detachNewThreadSelector:@selector(receiveMessageThread) toTarget:self withObject:nil];
}

- (void) dealloc {
	[_expectedMessages release];
	[super dealloc];
}

@end
