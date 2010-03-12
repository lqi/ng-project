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

#import "NGNetworkTest.h"

@implementation NGNetworkTest

- (void) testIsConnected {
	NGNetwork *labWaveServer = [[NGNetwork alloc] initWithHostDomain:@"192.168.131.5" port:9876];
	while (![labWaveServer isConnected]) {
	}
	STAssertTrue([labWaveServer isConnected], @"this test, at the moment, is very tricky, need to think about it later.");
}

@end
