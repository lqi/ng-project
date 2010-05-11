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
#import "NGHeader.h"
#import "NGTextViewEditingStyle.h"

@interface NGTextView : NSTextView <NGClientApplicationDelegate> {
	NGWaveId *_waveId;
	NGWaveletId *_waveletId;
	NGParticipantId *_participantId;
	NGDocumentId *_blipId;
	long _seqNo;
	NGClientRpc *_network;
	NGHashedVersion *_hashedVersion;
	
	NSMutableArray *_waveRpcItems;
	NSMutableArray *_ngElementAttributes;
	NSMutableArray *_ngElementAnnotations;
}

- (NSInteger)caretOffset;
- (NSInteger)caretOffsetOfPositionOffset:(int)positionOffset;
- (NSInteger)textLength;
- (NSInteger)positionOffset:(int)caretOffset;
- (NSInteger)positionLength;
- (NSInteger)positionOffsetOfCurrentLineStart:(int)caretOffset;
- (NSInteger)positionOffsetOfPreviousLineStart:(int)positionOffset;

- (void)insertCharacters:(NSString *)characters caretOffset:(int)caretOffset;
- (void)insertLineMutationDocument:(int)caretOffset;
- (void)deleteCurrentElement:(int)caretOffset;
- (void)updateAttributeInPosition:(int)positionOffset forKey:(NSString *)key value:(NSString *)value;
- (void)replaceAttributeInPosition:(int)positionOffset forKey:(NSString *)key oldValue:(NSString *)oldValue newValue:(NSString *)newValue;
- (void)sendDocumentOperation:(NGMutateDocument *)docOp;

- (void)openWithNetwork:(NGClientRpc *)network WaveId:(NGWaveId *)waveId waveletId:(NGWaveletId *)waveletId participantId:(NGParticipantId *)participantId sequenceNo:(long)seqNo;
- (void)close;

- (NSString *)openWaveId;

- (void)apply:(ProtocolWaveletOperation_MutateDocument *)mutateDocument;

- (long)seqNo;

- (void) setHashedVersion:(int64_t)theVersion withHistoryHash:(NSData *)theHistoryHash;
- (NGHashedVersion *) hashedVersion;

@end
