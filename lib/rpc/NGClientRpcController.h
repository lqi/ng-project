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
@class NGRpcState;

typedef enum {
	PENDING,
	ACTIVE,
	COMPLETE
} NGClientRpcControllerStatus;

@interface NGClientRpcController : NSObject {
	NGRpcState *state;
}

@property (retain) NGRpcState *state;

+ (NGClientRpcController *) rpcController;

- (NGClientRpcControllerStatus) status;
- (BOOL) checkStatus:(NGClientRpcControllerStatus) aimStatus;

- (void) configure:(NGRpcState *) theState;
- (void) response:(PBGeneratedMessage *)message;
- (void) failure:(NSString *)errorText;
- (BOOL) failed;
- (NSString *) errorText;
- (void) reset;
- (void) startCancel;

@end
