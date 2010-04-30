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

#import <Foundation/Foundation.h>

#import "../../id/NGParticipantId.h"
#import "../../document/operation/NGMutateDocument.h"
#import "../NGWaveletDelta.h"

#import "../NGWaveletDocOp.h"
#import "../NGAddParticipantOp.h"
#import "../NGRemoveParticipantOp.h"
#import "../NGNoOp.h"

@interface NGWaveletDeltaBuilder : NSObject {
	NGParticipantId *_author;
	NSMutableArray *_operations;
}

- (void) setAuthor:(NGParticipantId *)author;

+ (NGWaveletDeltaBuilder *) builder:(NGParticipantId *)author;

- (NGWaveletDeltaBuilder *) docOp:(NSString *)theDocumentId andMutateDocument:(NGMutateDocument *)theMutateDocument;
- (NGWaveletDeltaBuilder *) addParticipantOp:(NGParticipantId *)theParticipant;
- (NGWaveletDeltaBuilder *) removeParticipantOp:(NGParticipantId *)theParticipant;
- (NGWaveletDeltaBuilder *) noOp;

- (NGWaveletDelta *) build;

@end
