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

#import "NGWaveletIdTest.h"

@implementation NGWaveletIdTest

- (void) setUp {
	_waveletId = [[NGWaveletId alloc] init];
	_waveletId.domain = @"testDomain";
	_waveletId.waveletId = @"testId";
}

- (void) tearDown {
	[_waveletId release];
}

- (void) testDomain {
	STAssertEqualObjects([_waveletId domain], @"testDomain", @"domain should be 'testDomain'");
}

- (void) testWaveletId {
	STAssertEqualObjects([_waveletId waveletId], @"testId", @"waveId should be 'waveId'");
}

- (void) testEqualsCompareToSameObject {
	STAssertEqualObjects(_waveletId, _waveletId, @"WaveletId with samd object should be equal");
}

- (void) testEqualsCompareToNil {
	STAssertFalse([_waveletId isEqual:nil], @"WaveletId cannot equal to a nil object");
}

- (void) testEqualsCompareToDifferentType {
	STAssertFalse([_waveletId isEqual:@"NSString"], @"WaveletId cannot equal to an object with different type");
}

- (void) testEqualsCompareToSameValue {
	NGWaveletId *compareWaveletId = [NGWaveletId waveletIdWithDomain:@"testDomain" waveletId:@"testId"];
	STAssertEqualObjects(_waveletId, compareWaveletId, @"WaveletId with same domain and id should be equal");
}

@end
