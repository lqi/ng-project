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

#import "../../proto/Federation.pb.h"

#import "../id/NGParticipantId.h"

#import "NGWaveletOperation.h"

@interface NGRemoveParticipantOp : NSObject <NGWaveletOperation> {
	NGParticipantId *participantId;
}

@property (retain) NGParticipantId *participantId;

+ (NGRemoveParticipantOp *) removeParticipant:(NGParticipantId *)theParticipant;

@end
