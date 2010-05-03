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

#import "NGWaveletDeltaBuilder.h"

@implementation NGWaveletDeltaBuilder

- (id) init {
	if (self = [super init]) {
		_operations = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) setAuthor:(NGParticipantId *)author {
	_author = author;
}

+ (NGWaveletDeltaBuilder *) builder:(NGParticipantId *)author {
	NGWaveletDeltaBuilder *waveletDeltaBuilderInstance = [[[NGWaveletDeltaBuilder alloc] init] autorelease];
	[waveletDeltaBuilderInstance setAuthor:author];
	return waveletDeltaBuilderInstance;
}

- (NGWaveletDeltaBuilder *) docOp:(NGDocumentId *)theDocumentId andMutateDocument:(NGMutateDocument *)theMutateDocument {
	[self addOperation:[NGWaveletDocOp documentOperationWithDocumentId:theDocumentId andMutateDocument:theMutateDocument]];
	return self;
}

- (NGWaveletDeltaBuilder *) addParticipantOp:(NGParticipantId *)theParticipant {
	[self addOperation:[NGAddParticipantOp addParticipant:theParticipant]];
	return self;
}

- (NGWaveletDeltaBuilder *) removeParticipantOp:(NGParticipantId *)theParticipant {
	[self addOperation:[NGRemoveParticipantOp removeParticipant:theParticipant]];
	return self;
}

- (NGWaveletDeltaBuilder *) noOp {
	[self addOperation:[NGNoOp noOp]];
	return self;
}

- (void) addOperation:(id <NGWaveletOperation>)operation {
	[_operations addObject:operation];
}

- (NGWaveletDelta *) build {
	return [NGWaveletDelta waveletDeltaWithAuthor:_author andOperations:_operations];
}

- (void) dealloc {
	[_operations release];
	[_author release];
	[super dealloc];
}

@end
