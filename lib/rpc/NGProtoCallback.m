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

#import "NGProtoCallback.h"

@implementation NGProtoCallback

+ (NGProtoCallback *) callback {
	return [[[NGProtoCallback alloc] init] autorelease];
}

- (id) init {
	if (self = [super init]) {
		_activeControllerMap = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void) addController:(long)sequenceNo controller:(NGClientRpcController *)controller {
	@synchronized (_activeControllerMap) {
		[_activeControllerMap setValue:controller forKey:[NSString stringWithFormat:@"%d", sequenceNo]];
	}
}

- (NGClientRpcController *) getController:(long)sequenceNo {
	NGClientRpcController *controller;
	@synchronized (_activeControllerMap) {
		controller = [_activeControllerMap valueForKey:[NSString stringWithFormat:@"%d", sequenceNo]];
	}
	return controller;
}

- (void) message:(long)sequenceNo message:(PBGeneratedMessage *)message {
	NGClientRpcController *controller = [self getController:sequenceNo];
	if ([[[message class] description] isEqual:@"RpcFinished"]) {
		RpcFinished *finishedMessage = (RpcFinished *) message;
		if ([finishedMessage failed]) {
			[controller failure:[finishedMessage errorText]];
		}
		else {
			[controller response:nil];
		}
	}
	else {
		[controller response:message];
	}
}

- (void) unknown:(long)sequenceNo messageType:(NSString *)messageType {
	NGClientRpcController *controller = [self getController:sequenceNo];
	[controller failure:[NSString stringWithFormat:@"RPC got unknown message: %@", messageType]];
}

- (void) dealloc {
	[_activeControllerMap release];
	[super dealloc];
}

@end
