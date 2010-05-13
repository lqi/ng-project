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

#import "NGClientRpcController.h"

@implementation NGClientRpcController

@synthesize state;

+ (NGClientRpcController *) rpcController {
	return [[[NGClientRpcController alloc] init] autorelease];
}

- (NGClientRpcControllerStatus) status {
	return self.state == nil ? PENDING : self.state.complete ? COMPLETE : ACTIVE;
}

- (void) checkStatus:(NGClientRpcControllerStatus) aimStatus {
	NGClientRpcControllerStatus currentStatus = [self status];
	if (currentStatus != aimStatus) {
		[NSException raise:@"Illegal Status in NGClientRpcController" format:@"Current status of %d isn't matching aim status of %d", currentStatus, aimStatus];
	}
}

- (void) configure:(NGRpcState *) theState {
	[self checkStatus:PENDING];
	if (self.state == nil) {
		self.state = theState;
	}
	else {
		[NSException raise:@"Illegal Status in NGClientRpcController" format:@"Can't configure this RPC, as it's already configured."];
	}
}

- (void) response:(PBGeneratedMessage *)message {
	[self checkStatus:ACTIVE];
	/*
	if (!_state.isStreamingRpc) {
		if (message == nil) {
			[NSException raise:@"Illegal Status in NGClientRpcController" format:@"Normal RPCs should not be completed early."];
		}
		else {
			_state.complete = YES;
		}
	}
	else if (message == nil) {
		_state.complete = YES;
	}
	*/ // TODO: as isStreamingRpc doesn't work functional, comment this part to make the overal application running
	[self.state.callback onSuccess:message];
}

- (void) failure:(NSString *)errorText {
	[self checkStatus:ACTIVE];
	self.state.complete = YES;
	self.state.failed = YES;
	self.state.errorText = errorText;
	
	[self.state.callback onFailure:errorText];
}

- (BOOL) failed {
	[self checkStatus:COMPLETE];
	return self.state.failed;
}

- (NSString *) errorText {
	return [self failed] ? self.state.errorText : nil;
}

- (void) reset {
	[self checkStatus:COMPLETE];
    self.state = nil;
}

- (void) startCancel {
	NGClientRpcControllerStatus currentStatus = [self status];
	if (currentStatus == PENDING) {
		[NSException raise:@"Illegal Status in NGClientRpcController" format:@"Can't cancel this RPC, not currently active."];
	}
	else if (currentStatus == COMPLETE) {
		// TODO: keep silence at the moment
	}
	else {
		[self.state.cancelRpc startCancel];
	}
}

@end
