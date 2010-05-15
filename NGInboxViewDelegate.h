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

#import <Cocoa/Cocoa.h>

@class NGWaveDigest;

@interface NGInboxViewDelegate : NSObject /*<NSTableViewDataSource>*/ {
	NSMutableArray *inboxArray;
	NGParticipantId *currentUser;
}

@property (assign) NGParticipantId *currentUser;

- (NGWaveId *) getWaveIdByRowIndex:(NSInteger)rowIndex;
- (NSInteger) getIndexFromWaveName:(NGWaveName *)waveName;
- (NGWaveDigest *) getDigestFromIndex:(NSInteger)index andWaveName:(NGWaveName *)waveName;
- (void) updateDigest:(NGWaveDigest *)digest withIndex:(NSInteger)index;

- (void) addParticipant:(NGParticipantId *)participantId fromAuthor:(NGParticipantId *)author forWavelet:(NGWaveName *)waveName;
- (void) removeParticipant:(NGParticipantId *)participantId fromAuthor:(NGParticipantId *)author forWavelet:(NGWaveName *)waveName;
- (void) waveletDocument:(ProtocolWaveletOperation_MutateDocument *)document fromAuthor:(NGParticipantId *)author forWavelet:(NGWaveName *)waveName;

@end
