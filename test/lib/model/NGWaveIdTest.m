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

#import "NGWaveIdTest.h"

@implementation NGWaveIdTest

- (void) setUp {
	_waveId = [[NGWaveId alloc] init];
	_waveId.domain = @"testDomain";
	_waveId.waveId = @"testId";
}

- (void) tearDown {
	[_waveId release];
}

- (void) testDomain {
	STAssertEqualObjects([_waveId domain], @"testDomain", @"domain should be 'testDomain'");
}

- (void) testWaveId {
	STAssertEqualObjects([_waveId waveId], @"testId", @"waveId should be 'waveId'");
}

- (void) testWaveIdFollowedByDomain {
	STAssertEqualObjects([_waveId serialise], @"testDomain!testId", @"waveIdFollowedByDomain should be 'testDomain!testId");
}

- (void) testEqualsCompareToSameObject {
	STAssertEqualObjects(_waveId, _waveId, @"WaveId with samd object should be equal");
}

- (void) testEqualsCompareToNil {
	STAssertFalse([_waveId isEqual:nil], @"WaveId cannot equal to a nil object");
}

- (void) testEqualsCompareToDifferentType {
	STAssertFalse([_waveId isEqual:@"NSString"], @"WaveId cannot equal to an object with different type");
}

- (void) testEqualsCompareToSameValue {
	NGWaveId *compareWaveId = [NGWaveId waveIdWithDomain:@"testDomain" waveId:@"testId"];
	STAssertEqualObjects(_waveId, compareWaveId, @"WaveId with same domain and id should be equal");
}

- (void) testDeserialise {
	NGWaveId *waveId = [[NGWaveId alloc] init];
	[waveId deserialise:@"testDomain!testId"];
	STAssertEqualObjects(waveId.domain, @"testDomain", @"domain should be 'testDomain'");
	STAssertEqualObjects(waveId.waveId, @"testId", @"id should be 'testId'");
	[waveId release];
}

- (void) testDeserialiseInstance {
	NGWaveId *waveId = [NGWaveId waveIdWithSerialisedWaveId:@"testDomain!testId"];
	STAssertEqualObjects(_waveId, waveId, @"too waveid should be same");
}

@end
