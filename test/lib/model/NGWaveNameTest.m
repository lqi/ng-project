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

#import "NGWaveNameTest.h"

@implementation NGWaveNameTest

- (void) setUp {
	_waveName = [[NGWaveName alloc] initWithString:@"wave://testDomain/testWaveId/testWaveletId"];
}

- (void) tearDown {
	[_waveName release];
}

- (void) testWaveId {
	STAssertEqualObjects([_waveName waveId], [NGWaveId waveIdWithDomain:@"testDomain" waveId:@"testWaveId"], @"waveId should be 'testWaveId@testDomain'");
}

- (void) testWaveletId {
	STAssertEqualObjects([_waveName waveletId], [NGWaveletId waveletIdWithDomain:@"testDomain" waveletId:@"testWaveletId"], @"waveletId should be 'testWaveletId@testDomain'");
}

- (void) testDomain {
	STAssertEqualObjects([_waveName domain], @"testDomain", @"domain should be 'testDomain'");
}

- (void) testStringValue {
	NGWaveName *testUrl = [[NGWaveName alloc] init];
	[testUrl setWaveId:[NGWaveId waveIdWithDomain:@"testWaveDomain" waveId:@"testWaveId"]];
	[testUrl setWaveletId:[NGWaveletId waveletIdWithDomain:@"testDomain" waveletId:@"testWaveletId"]];
	STAssertEqualObjects([testUrl url], @"wave://testDomain/testWaveId/testWaveletId", @"string value of this wave url should be 'wave://testDomain/testWaveId/testWaveletId'");
}

@end
