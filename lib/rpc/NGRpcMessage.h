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

#import "ProtocolBuffers.h"

#import "../proto/WaveclientRpc.pb.h"

#import "../model/id/NGWaveId.h"
#import "../model/id/NGWaveName.h"
#import "../model/id/NGParticipantId.h"
#import "../model/operation/NGWaveletDelta.h"
#import "../model/operation/NGHashedVersion.h"
#import "../model/operation/util/NGWaveletDeltaSerializer.h"

@interface NGRpcMessage : NSObject {
	long sequenceNo;
	PBGeneratedMessage *message;
}

@property long sequenceNo;
@property (retain) PBGeneratedMessage *message;

+ (NGRpcMessage *)rpcMessage:(PBGeneratedMessage *)pbMessage sequenceNo:(long)sequence;

@end
