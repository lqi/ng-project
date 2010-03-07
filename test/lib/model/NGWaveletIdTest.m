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
	_waveletId = [[NGWaveletId alloc] initWithDomain:@"testDomain" waveletId:@"testId"];
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

- (void) testEquals {
	NGWaveletId *compareWaveletId = [[NGWaveletId alloc] initWithDomain:@"testDomain" waveletId:@"testId"];
	STAssertEqualObjects(_waveletId, compareWaveletId, @"WaveId with same domain and id should be equal");
	[compareWaveletId release];
}

@end
