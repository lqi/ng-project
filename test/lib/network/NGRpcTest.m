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

#import "NGRpcTest.h"

@implementation NGRpcTest

- (void) setUp
{
    rpc = [[NGRpc alloc] initWithHostAddress:@"192.168.1.5" port:9876];
}

- (void) tearDown
{
    [rpc release];
}

- (void) testCanary {
	STAssertTrue(YES, @"test canary");
}

- (void) testIsConnected {
	STAssertTrue([rpc isConnected], @"a rpc object connecting to the test wave server");
}

- (void) testIsNotConnected {
	NGRpc *testRpc = [[NGRpc alloc] init];
	STAssertFalse([testRpc isConnected], @"a rpc object without connecting to the server");
	[testRpc release];
}

@end
