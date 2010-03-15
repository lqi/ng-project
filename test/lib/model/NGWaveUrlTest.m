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

#import "NGWaveUrlTest.h"

@implementation NGWaveUrlTest

- (void) setUp {
	_waveUrl = [[NGWaveUrl alloc] initWithString:@"wave://testDomain/testWaveId/testWaveletId"];
}

- (void) tearDown {
	[_waveUrl release];
}

- (void) testWaveId {
	STAssertEqualObjects([_waveUrl waveId], [NGWaveId waveIdWithDomain:@"testDomain" waveId:@"testWaveId"], @"waveId should be 'testWaveId@testDomain'");
}

- (void) testWaveletId {
	STAssertEqualObjects([_waveUrl waveletId], [NGWaveletId waveletIdWithDomain:@"testDomain" waveletId:@"testWaveletId"], @"waveletId should be 'testWaveletId@testDomain'");
}

- (void) testStringValue {
	NGWaveUrl *testUrl = [[NGWaveUrl alloc] init];
	[testUrl setWaveId:[NGWaveId waveIdWithDomain:@"testWaveDomain" waveId:@"testWaveId"]];
	[testUrl setWaveletId:[NGWaveletId waveletIdWithDomain:@"testDomain" waveletId:@"testWaveletId"]];
	STAssertEqualObjects([testUrl stringValue], @"wave://testDomain/testWaveId/testWaveletId", @"string value of this wave url should be 'wave://testDomain/testWaveId/testWaveletId'");
}

@end
