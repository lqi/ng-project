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

#import "NGWaveletDeltaBuilderTest.h"

@interface NGTestWaveletOperationForWaveletDeltaBuilder : NSObject <NGWaveletOperation> {
}

- (NSString *) aTestDelta;
+ (NGTestWaveletOperationForWaveletDeltaBuilder *) delta;

@end

@implementation NGTestWaveletOperationForWaveletDeltaBuilder

- (NSString *) aTestDelta {
	return @"ForTest";
}

+ (NGTestWaveletOperationForWaveletDeltaBuilder *) delta {
	return [[[NGTestWaveletOperationForWaveletDeltaBuilder alloc] init] autorelease];
}

- (ProtocolWaveletOperation *) buffer {
	ProtocolWaveletOperation_Builder *waveletOpBuilder = [ProtocolWaveletOperation builder];
	return [waveletOpBuilder build];
}

@end

@implementation NGWaveletDeltaBuilderTest

- (void) testAddOperation {
	NGParticipantId *participant = [NGParticipantId participantIdWithDomain:@"testDomain" participantId:@"testParticipant"];
	NGWaveletDeltaBuilder *waveletDeltaBuilder = [NGWaveletDeltaBuilder builder:participant];
	[waveletDeltaBuilder addOperation:[NGTestWaveletOperationForWaveletDeltaBuilder delta]];
	NGWaveletDelta *testDelta = [waveletDeltaBuilder build];
	NSArray *testOperations = [testDelta operations];
	STAssertTrue([testOperations count] == 1, @"Current wavelet delta should have only one operation");
	STAssertEqualObjects([[testOperations objectAtIndex:0] aTestDelta], @"ForTest", @"current operation should has a test delta with 'ForTest'");
	STAssertEqualObjects([testDelta author], participant, @"current wavelet delta should have this author");
}

@end
