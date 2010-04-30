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

#import "NGRandomIdGeneratorTest.h"

@implementation NGRandomIdGeneratorTest

- (void) setUp {
	_idGenerator = [[NGRandomIdGenerator alloc] initWithDomain:@"testDomain"];
}

- (void) tearDown {
	[_idGenerator release];
}

- (void) testNewWaveId {
	NGWaveId *testWaveId = [_idGenerator newWaveId];
	STAssertEqualObjects([testWaveId domain], @"testDomain", @"domain should be 'testDomain'");
	NSString *testWaveIdString = [testWaveId waveId];
	STAssertEqualObjects([testWaveIdString substringToIndex:2], @"w+", @"waveId should start with 'w+'");
	STAssertTrue([testWaveIdString length] == 14, @"Length of waveIdString should be 14");
}

- (void) testNewConversationWaveletId {
	NGWaveletId *testWaveletId = [_idGenerator newConversationWaveletId];
	STAssertEqualObjects([testWaveletId domain], @"testDomain", @"domain should be 'testDomain'");
	NSString *testWaveletIdString = [testWaveletId waveletId];
	STAssertEqualObjects([testWaveletIdString substringToIndex:5], @"conv+", @"waveId should start with 'conv+'");
	STAssertTrue([testWaveletIdString length] == 13, @"Length of testWaveletIdString should be 13");
}

- (void) testNewConversationRootWaveletId {
	NGWaveletId *testWaveletId = [_idGenerator newConversationRootWaveletId];
	STAssertEqualObjects([testWaveletId domain], @"testDomain", @"domain should be 'testDomain'");
	STAssertEqualObjects([testWaveletId waveletId], @"conv+root", @"waveletId should be 'conv+root'");
}

- (void) testNewDocumentId {
	NSString *testDocumentId = [_idGenerator newDocumentId];
	STAssertEqualObjects([testDocumentId substringToIndex:2], @"b+", @"documentId should start with 'b+'");
	STAssertTrue([testDocumentId length] == 8, @"Length of testDocumentId should be 8");
}

@end
