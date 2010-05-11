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

@class NGClientRpcCallback;
@class NGCancelRpc;

@interface NGRpcState : NSObject {
	BOOL isStreamingRpc;
	NGClientRpcCallback *callback;
	NGCancelRpc *cancelRpc;
	BOOL complete;
	BOOL failed;
	NSString *errorText;
}

@property BOOL isStreamingRpc;
@property (retain) NGClientRpcCallback *callback;
@property (retain) NGCancelRpc *cancelRpc;
@property BOOL complete;
@property BOOL failed;
@property (retain) NSString *errorText;

- (id) initWithStreamRpc:(BOOL)streamRpc rpcCallback:(NGClientRpcCallback *)rpcCallback andCancelRpc:(NGCancelRpc *)theCancelRpc;

@end

/*
 private final ClientRpcChannel creator;
 private final boolean isStreamingRpc;
 private final RpcCallback<Message> callback;
 private final Runnable cancelRpc;
 private boolean complete = false;
 private boolean failed = false;
 private String errorText = null;
 
 RpcState(ClientRpcChannel creator, boolean isStreamingRpc, RpcCallback<Message> callback,
 Runnable cancelRpc) {
 this.creator = creator;
 this.isStreamingRpc = isStreamingRpc;
 this.callback = callback;
 this.cancelRpc = cancelRpc;
 }
 */
