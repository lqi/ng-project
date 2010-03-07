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

@end

@implementation NGNetwork

@synthesize pbOutputStream;
@synthesize pbInputStream;

- (id) initWithHostName:(NSString *)name port:(NSInteger)port {
	if (self = [super init]) {
		NSHost *host = [NSHost hostWithName:name];
		[self connectToHost:host port:port];
	}
	return self;
}

- (id) initWithHostAddress:(NSString *)address port:(NSInteger)port {
	if (self = [super init]) {
		NSHost *host = [NSHost hostWithAddress:address];
		[self connectToHost:host port:port];
	}
	return self;
}

- (id) initWithHost:(NSHost *)host port:(NSInteger)port {
	if (self = [super init]) {
		[self connectToHost:host port:port];
	}
	return self;
}

- (void) connectToHost:(NSHost *)host port:(NSInteger)port {
	[NSStream getStreamsToHost:host port:9876 inputStream:&_inputStream outputStream:&_outputStream];
	[_inputStream retain];
	[_outputStream retain];
	[_inputStream setDelegate:self];
	[_outputStream setDelegate:self];
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

- (BOOL) isConnected {
	return [self isStreamOpen:_inputStream] && [self isStreamOpen:_outputStream];
}

- (void) stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
	if (eventCode == NSStreamEventHasBytesAvailable) {
	}
}

- (void) dealloc {
	[pbInputStream release];
	[pbOutputStream release];
	[_inputStream release];
	[_outputStream release];
	[super dealloc];
}	

@end
