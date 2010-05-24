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

#import "NGWaveletNameTest.h"

@implementation NGWaveletNameTest

- (void) setUp {
	_waveletName = [[NGWaveletName alloc] init];
	_waveletName.waveId = [NGWaveId waveIdWithDomain:@"testDomain" waveId:@"testWaveId"];
	_waveletName.waveletId = [NGWaveletId waveletIdWithDomain:@"testDomain" waveletId:@"testWaveletId"];
}

- (void) tearDown {
	[_waveletName release];
}

- (void) testWaveId {
	STAssertEqualObjects(_waveletName.waveId, [NGWaveId waveIdWithDomain:@"testDomain" waveId:@"testWaveId"], @"waveId should be 'testWaveId@testDomain'");
}

- (void) testWaveletId {
	STAssertEqualObjects(_waveletName.waveletId, [NGWaveletId waveletIdWithDomain:@"testDomain" waveletId:@"testWaveletId"], @"waveletId should be 'testWaveletId@testDomain'");
}

- (void) testDomain {
	STAssertEqualObjects([_waveletName domain], @"testDomain", @"domain should be 'testDomain'");
}

- (void) testStringValue {
	STAssertEqualObjects([_waveletName serialise], @"wave://testDomain/testWaveId/testWaveletId", @"string value of this wave url should be 'wave://testDomain/testWaveId/testWaveletId'");
}

- (void) testDeserialise {
	NGWaveletName *testName = [NGWaveletName waveletNameWithSerialisedWaveletName:@"wave://testDomain/testWaveId/testWaveletId"];
	STAssertEqualObjects(testName.waveId, [NGWaveId waveIdWithDomain:@"testDomain" waveId:@"testWaveId"], @"waveId should be 'testWaveId@testDomain'");
	STAssertEqualObjects(testName.waveletId, [NGWaveletId waveletIdWithDomain:@"testDomain" waveletId:@"testWaveletId"], @"waveletId should be 'testWaveletId@testDomain'");
}

- (void) testEqualsCompareToSameObject {
	STAssertEqualObjects(_waveletName, _waveletName, @"WaveletName with samd object should be equal");
}

- (void) testEqualsCompareToNil {
	STAssertFalse([_waveletName isEqual:nil], @"WaveletName cannot equal to a nil object");
}

- (void) testEqualsCompareToDifferentType {
	STAssertFalse([_waveletName isEqual:@"NSString"], @"WaveletName cannot equal to an object with different type");
}

- (void) testEqualsCompareToSameValue {
	NGWaveletName *compareWaveletName = [NGWaveletName waveletNameWithSerialisedWaveletName:@"wave://testDomain/testWaveId/testWaveletId"];
	STAssertEqualObjects(_waveletName, compareWaveletName, @"WaveletName with same domain and id should be equal");
}

@end
