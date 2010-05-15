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

#import "NGClientRpcChannel.h"

@implementation NGClientRpcChannel

- (id) initWithHost:(NGHost *)host {
	if (self = [super init]) {
		_lastSequenceNo = 0;
		_callback = [NGProtoCallback callback];
		_protoChannel = [[NGSequencedProtoChannel alloc] initWithHost:host callback:_callback];
		[_protoChannel expectMessage:[RpcFinished defaultInstance]];
		[_protoChannel startAsyncRead];
	}
	return self;
}

- (long) increaseAndGetSequenceNo {
	_lastSequenceNo++;
	return _lastSequenceNo;
}

- (void) sendMessage:(long)sequenceNo message:(PBGeneratedMessage *)message prototype:(PBGeneratedMessage *)responsePrototype {
	[_protoChannel sendMessage:sequenceNo message:message withExpectedResponsePrototype:responsePrototype];
}

- (void) sendMessage:(long)sequenceNo message:(PBGeneratedMessage *)message {
	[_protoChannel sendMessage:sequenceNo message:message];
}

- (void) callMethod:(BOOL)isStreamingRpc rpcController:(NGClientRpcController *)controller requestMessage:(PBGeneratedMessage *)message responsePrototype:(PBGeneratedMessage *)responsePrototype callback:(NGClientRpcCallback *)callback {
	long sequenceNo = [self increaseAndGetSequenceNo];
	NGCancelRpc *cancelRpc = [NGCancelRpc cancelRpcWithSequenceNo:sequenceNo channel:self];
	NGRpcState *rpcState = [NGRpcState rpcStateWithStreamRpc:isStreamingRpc rpcCallback:callback andCancelRpc:cancelRpc];
	[controller configure:rpcState];
	[_callback addController:sequenceNo controller:controller];
	
	[self sendMessage:sequenceNo message:message prototype:responsePrototype];
}

- (BOOL) isConnected {
	return [_protoChannel isConnected];
}

- (void) dealloc {
	[_protoChannel release];
	[super dealloc];
}

@end
