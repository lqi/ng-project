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

#import "NGClientRpc.h"

@implementation NGClientRpc

@synthesize channel;

- (id) initWithChannel:(NGClientRpcChannel *)aChannel {
	if (self = [super init]) {
		self.channel = aChannel;
	}
	return self;
}

- (void) open:(NGClientRpcController *)controller request:(ProtocolOpenRequest *)request callback:(NGClientRpcCallback *)callback {
	[self.channel callMethod:YES rpcController:controller requestMessage:request responsePrototype:[ProtocolWaveletUpdate defaultInstance] callback:callback];
}

- (void) submit:(NGClientRpcController *)controller request:(ProtocolSubmitRequest *)request callback:(NGClientRpcCallback *)callback {
	[self.channel callMethod:NO rpcController:controller requestMessage:request responsePrototype:[ProtocolSubmitResponse defaultInstance] callback:callback];
}

- (void) openRequest:(NGClientRpcController *)controller waveId:(NGWaveId *)waveId participantId:(NGParticipantId *)participantId snapshot:(BOOL)snapshot callback:(NGClientRpcCallback *)callback {
	ProtocolOpenRequest_Builder *openRequestBuilder = [ProtocolOpenRequest builder];
	[openRequestBuilder setParticipantId:[participantId serialise]];
	[openRequestBuilder setWaveId:[waveId serialise]];
	[openRequestBuilder setSnapshots:snapshot];
	[self open:controller request:[openRequestBuilder build] callback:callback];
}

- (void) submitRequest:(NGClientRpcController *)controller waveName:(NGWaveletName *)waveName waveletDelta:(NGWaveletDelta *)delta hashedVersion:(NGHashedVersion *)version callback:(NGClientRpcCallback *)callback {
	ProtocolSubmitRequest_Builder *submitRequestBuilder = [ProtocolSubmitRequest builder];
	[submitRequestBuilder setWaveletName:[waveName url]];
	[submitRequestBuilder setDelta:[NGWaveletDeltaSerializer bufferedWaveletDelta:delta withVersion:version]];
	[self submit:controller request:[submitRequestBuilder build] callback:callback];
}

@end
