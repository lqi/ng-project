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

- (void) setChannel:(NGClientRpcChannel *)channel {
	_channel = channel;
}

+ (NGClientRpc *) clientRpc:(NGClientRpcChannel *)channel {
	NGClientRpc *clientRpcInstance = [[[NGClientRpc alloc] init] autorelease];
	[clientRpcInstance setChannel:channel];
	return clientRpcInstance;
}

- (void) open:(NGClientRpcController *)controller request:(ProtocolOpenRequest *)request callback:(NGClientRpcCallback *)callback {
	/*
	 public  void open(
	 com.google.protobuf.RpcController controller,
	 org.waveprotocol.wave.examples.fedone.waveserver.WaveClientRpc.ProtocolOpenRequest request,
	 com.google.protobuf.RpcCallback<org.waveprotocol.wave.examples.fedone.waveserver.WaveClientRpc.ProtocolWaveletUpdate> done) {
	 channel.callMethod(
	 getDescriptor().getMethods().get(0),
	 controller,
	 request,
	 org.waveprotocol.wave.examples.fedone.waveserver.WaveClientRpc.ProtocolWaveletUpdate.getDefaultInstance(),
	 com.google.protobuf.RpcUtil.generalizeCallback(
	 done,
	 org.waveprotocol.wave.examples.fedone.waveserver.WaveClientRpc.ProtocolWaveletUpdate.class,
	 org.waveprotocol.wave.examples.fedone.waveserver.WaveClientRpc.ProtocolWaveletUpdate.getDefaultInstance()));
	 }
	 */
	[_channel callMethod:nil rpcController:controller requestMessage:request responsePrototype:[ProtocolWaveletUpdate defaultInstance] callback:callback];
}

- (void) submit:(NGClientRpcController *)controller request:(ProtocolSubmitRequest *)request callback:(NGClientRpcCallback *)callback {
	/*
	 public  void submit(
	 com.google.protobuf.RpcController controller,
	 org.waveprotocol.wave.examples.fedone.waveserver.WaveClientRpc.ProtocolSubmitRequest request,
	 com.google.protobuf.RpcCallback<org.waveprotocol.wave.examples.fedone.waveserver.WaveClientRpc.ProtocolSubmitResponse> done) {
	 channel.callMethod(
	 getDescriptor().getMethods().get(1),
	 controller,
	 request,
	 org.waveprotocol.wave.examples.fedone.waveserver.WaveClientRpc.ProtocolSubmitResponse.getDefaultInstance(),
	 com.google.protobuf.RpcUtil.generalizeCallback(
	 done,
	 org.waveprotocol.wave.examples.fedone.waveserver.WaveClientRpc.ProtocolSubmitResponse.class,
	 org.waveprotocol.wave.examples.fedone.waveserver.WaveClientRpc.ProtocolSubmitResponse.getDefaultInstance()));
	 }
	 }
	 */
	[_channel callMethod:nil rpcController:controller requestMessage:request responsePrototype:[ProtocolSubmitResponse defaultInstance] callback:callback];
}

@end
