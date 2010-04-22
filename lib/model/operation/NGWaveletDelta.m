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

#import "NGWaveletDelta.h"

@implementation NGWaveletDelta

@synthesize author;

- (id) init {
	if (self = [super init]) {
		_operations = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (NGWaveletDelta *) waveletDelta {
	return [[[NGWaveletDelta alloc] init] autorelease];
}

+ (NGWaveletDelta *) waveletDeltaWithAuthor:(NGParticipantId *)theAuthor {
	NGWaveletDelta *waveletDeltaInstance = [[[NGWaveletDelta alloc] init] autorelease];
	waveletDeltaInstance.author = theAuthor;
	return waveletDeltaInstance;
}

+ (NGWaveletDelta *) waveletDeltaWithAuthor:(NGParticipantId *)theAuthor andOperations:(NSArray *)theOperations {
	NGWaveletDelta *waveletDeltaInstance = [[[NGWaveletDelta alloc] init] autorelease];
	waveletDeltaInstance.author = theAuthor;
	[waveletDeltaInstance setOperations:theOperations];
	return waveletDeltaInstance;
}

- (void) addOperation:(id <NGWaveletOperation>)operation {
	[_operations addObject:operation];
}

- (void) setOperations:(NSArray *)theOperations {
	for (id <NGWaveletOperation> operation in theOperations) {
		[self addOperation:operation];
	}
}

- (ProtocolWaveletDelta *) bufferWithVersion:(ProtocolHashedVersion *)version {
	ProtocolWaveletDelta_Builder *deltaBuilder = [ProtocolWaveletDelta builder];
	[deltaBuilder setAuthor:[self.author participantIdAtDomain]];
	for (id <NGWaveletOperation> operation in _operations) {
		[deltaBuilder addOperation:[operation buffer]];
	}
	[deltaBuilder setHashedVersion:version];
	return [deltaBuilder build];
}

- (void) dealloc {
	[_operations release];
	[super dealloc];
}

@end
