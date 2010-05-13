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

#import "NGRpcState.h"

@implementation NGRpcState

@synthesize isStreamingRpc;
@synthesize callback;
@synthesize cancelRpc;
@synthesize complete;
@synthesize failed;
@synthesize errorText;

+ (NGRpcState *) rpcStateWithStreamRpc:(BOOL)streamRpc rpcCallback:(NGClientRpcCallback *)rpcCallback andCancelRpc:(NGCancelRpc *)theCancelRpc {
	return [[[NGRpcState alloc] initWithStreamRpc:streamRpc rpcCallback:rpcCallback andCancelRpc:theCancelRpc] autorelease];
}

- (id) initWithStreamRpc:(BOOL)streamRpc rpcCallback:(NGClientRpcCallback *)rpcCallback andCancelRpc:(NGCancelRpc *)theCancelRpc {
	if (self = [super init]) {
		self.complete = NO;
		self.failed = NO;
		self.errorText = nil;
		self.isStreamingRpc = streamRpc;
		self.callback = rpcCallback;
		self.cancelRpc = theCancelRpc;
	}
	return self;
}

@end
