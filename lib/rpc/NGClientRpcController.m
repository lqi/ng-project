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

+ (NGClientRpcController *) rpcController {
	return [[[NGClientRpcController alloc] init] autorelease];
}

- (NGClientRpcControllerStatus) status {
	return _state == nil ? PENDING : _state.complete ? COMPLETE : ACTIVE;
	//return state == null ? Status.PENDING : (state.complete ? Status.COMPLETE : Status.ACTIVE);
}

- (BOOL) checkStatus:(NGClientRpcControllerStatus) aimStatus {
	NGClientRpcControllerStatus currentStatus = [self status];
	return currentStatus == aimStatus;
	/*
	 Status currentStatus = status();
	 if (!currentStatus.equals(statusToAssert)) {
	 throw new IllegalStateException("Controller expected status " + statusToAssert + ", was "
	 + currentStatus);
	 }
	 */
}

- (void) configure:(NGRpcState *) state {
	if ([self checkStatus:PENDING]) {
		if (_state == nil) {
			_state = state;
		}
		else {
			// TODO: ignore at the moment;
		}
	}
	else {
		// TODO: ignore at the moment;
	}
	/*
	 checkStatus(Status.PENDING);
	 if (this.state != null) {
	 throw new IllegalStateException("Can't configure this RPC, already configured.");
	 } else if (!owner.equals(state.creator)) {
	 throw new IllegalArgumentException("Should only be configured by " + owner
	 + ", configuration attempted by " + state.creator);
	 }
	 this.state = state;
	 */
}

- (void) response:(PBGeneratedMessage *)message {
	if ([self checkStatus:ACTIVE]) {
		/*
		if (!_state.isStreamingRpc) {
			if (message == nil) {
				// TODO: thorw exception
			}
			else {
				_state.complete = YES;
			}
		}
		else if (message == nil) {
			_state.complete = YES;
		}
		 */
		[_state.callback run:message];
	}
	else {
		// TODO: ignore at the moment
	}

	/*
	 checkStatus(Status.ACTIVE);
	 // Any message will complete a normal RPC, whereas only a null message will
	 // end a streaming RPC.
	 if (!state.isStreamingRpc) {
	 if (message == null) {
	 // The server end-point should not actually allow non-streaming RPCs
	 // to call back with null messages - we should never get here.
	 throw new IllegalStateException("Normal RPCs should not be completed early.");
	 } else {
	 // Normal RPCs will complete on any valid incoming message.
	 state.complete = true;
	 }
	 } else if (message == null) {
	 // Complete this streaming RPC with this blank message.
	 state.complete = true;
	 }
	 try {
	 state.callback.run(message);
	 } catch (RuntimeException e) {
	 e.printStackTrace();
	 }
	 */
}

- (void) failure:(NSString *)errorText {
	if ([self checkStatus:ACTIVE]) {
		_state.complete = YES;
		_state.failed = YES;
		_state.errorText = errorText;
		
		[_state.callback failure];
	}
	else {
		// TODO: ignore at the moment
	}

	/*
	 checkStatus(Status.ACTIVE);
	 state.complete = true;
	 state.failed = true;
	 state.errorText = errorText;
	 
	 // Hint to the internal callback that this RPC is finished (Normal RPCs
	 // will always understand this as an error case, whereas streaming RPCs
	 // will have to check their controller).
	 state.callback.run(null);
	 */
}

- (BOOL) failed {
	if ([self checkStatus:COMPLETE]) {
		return _state.failed;
	}
	return NO; // TODO: ignore at the moment, should be an excpetion in checkStatus method
}

- (NSString *) errorText {
	return [self failed] ? _state.errorText : nil;
}

- (void) reset {
	[self checkStatus:COMPLETE];
    _state = nil;
}

- (void) startCancel {
	NGClientRpcControllerStatus currentStatus = [self status];
	if (currentStatus == PENDING) {
		// TODO: IllegalStateException("Can't cancel this RPC, not currently active.");
	}
	else if (currentStatus == COMPLETE) {
		// TODO: keep silence at the moment
	}
	else {
		[_state.cancelRpc startCancel];
	}

	/*
	 Status status = status();
	 if (status == Status.PENDING) {
	 throw new IllegalStateException("Can't cancel this RPC, not currently active.");
	 } else if (status == Status.COMPLETE) {
	 // We drop these requests silently - since there is no way for the client
	 // to know whether the RPC has finished while they are setting up their
	 // cancellation.
	 } else {
	 state.cancelRpc.run();
	 }
	 */
}

@end
