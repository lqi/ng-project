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

#import "NGNetwork.h"

@interface NGNetwork()

- (BOOL) isStreamOpen:(NSStream *)stream;

+ (void) getStreamsToHostName:(NSString *)domain port:(NSInteger)port inputStream:(NSInputStream **)inputStreamPtr outputStream:(NSOutputStream **)outputStreamPtr;

@end


@implementation NGNetwork

@synthesize pbOutputStream;
@synthesize pbInputStream;

+ (void) getStreamsToHostName:(NSString *)domain port:(NSInteger)port inputStream:(NSInputStream **)inputStreamPtr outputStream:(NSOutputStream **)outputStreamPtr {
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

- (id) initWithHostDomain:(NSString *)domain port:(NSInteger)port {
	if (self = [super init]) {
		[self connectToHost:domain port:port];
	}
	return self;
}

- (void) connectToHost:(NSString *)domain port:(NSInteger)port {
	[NGNetwork getStreamsToHostName:domain port:9876 inputStream:&_inputStream outputStream:&_outputStream];
	[_inputStream retain];
	[_outputStream retain];
	[_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	pbOutputStream = [PBCodedOutputStream streamWithOutputStream:_outputStream];
	[pbOutputStream retain];
	
	pbInputStream = [PBCodedInputStream streamWithInputStream:_inputStream];
	[pbInputStream retain];
}

- (BOOL) isStreamOpen:(NSStream *)stream {
	NSInteger streamStatus = [stream streamStatus];
	if (streamStatus >= 2 && streamStatus <= 5) {
		return YES;
	}
	return NO;
}

- (BOOL) callbackAvailable {
	return [_inputStream hasBytesAvailable];
}

- (BOOL) isConnected {
	return [self isStreamOpen:_inputStream] && [self isStreamOpen:_outputStream];
}

- (void) dealloc {
	[pbInputStream release];
	[pbOutputStream release];
	[_inputStream release];
	[_outputStream release];
	[super dealloc];
}

@end
