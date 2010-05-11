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

@class ProtocolOpenRequest;
@class ProtocolSubmitRequest;
@class NGClientRpcChannel;
@class NGClientRpcController;
@class NGClientRpcCallback;

@interface NGClientRpc : NSObject {
	NGClientRpcChannel *channel;
}

@property (retain) NGClientRpcChannel *channel;

- (id) initWithChannel:(NGClientRpcChannel *)aChannel;

- (void) open:(NGClientRpcController *)controller request:(ProtocolOpenRequest *)request callback:(NGClientRpcCallback *)callback;
- (void) submit:(NGClientRpcController *)controller request:(ProtocolSubmitRequest *)request callback:(NGClientRpcCallback *)callback;

- (void) openRequest:(NGClientRpcController *)controller waveId:(NGWaveId *)waveId participantId:(NGParticipantId *)participantId callback:(NGClientRpcCallback *)callback;
- (void) submitRequest:(NGClientRpcController *)controller waveName:(NGWaveName *)waveName waveletDelta:(NGWaveletDelta *)delta hashedVersion:(NGHashedVersion *)version callback:(NGClientRpcCallback *)callback;

@end
