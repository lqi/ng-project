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

@class PBGeneratedMessage;
@class NGHost;
@class NGSequencedProtoChannel;
@class NGRpcMessage;
@class NGProtoCallback;
@class NGCancelRpc;
@class NGRpcState;
@class NGClientRpcController;
@class NGClientRpcCallback;

@interface NGClientRpcChannel : NSObject {
	NGSequencedProtoChannel *_protoChannel;
	long _lastSequenceNo;
	NGProtoCallback *_callback;
}

+ (NGClientRpcChannel *) channelWithHost:(NGHost *)host;

- (id) initWithHost:(NGHost *)host;

- (long) increaseAndGetSequenceNo;

- (void) sendMessage:(NGRpcMessage *)message prototype:(PBGeneratedMessage *)responsePrototype;
- (void) sendMessage:(NGRpcMessage *)message;

- (void) callMethod:(NSString *)method rpcController:(NGClientRpcController *)controller requestMessage:(PBGeneratedMessage *)message responsePrototype:(PBGeneratedMessage *)responsePrototype callback:(NGClientRpcCallback *)callback;

@end
