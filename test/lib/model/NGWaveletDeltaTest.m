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

#import "NGWaveletDeltaTest.h"

@interface NGTestWaveletOperationForWaveletDelta : NSObject <NGWaveletOperation> {
}

- (NSString *) aTestDelta;
+ (NGTestWaveletOperationForWaveletDelta *) delta;

@end

@implementation NGTestWaveletOperationForWaveletDelta

- (NSString *) aTestDelta {
	return @"ForTest";
}

+ (NGTestWaveletOperationForWaveletDelta *) delta {
	return [[[NGTestWaveletOperationForWaveletDelta alloc] init] autorelease];
}

- (ProtocolWaveletOperation *) buffer {
	ProtocolWaveletOperation_Builder *waveletOpBuilder = [ProtocolWaveletOperation builder];
	return [waveletOpBuilder build];
}

@end

@implementation NGWaveletDeltaTest

- (void) setUp {
	_waveletDelta = [[NGWaveletDelta alloc] init];
}

- (void) tearDown {
	[_waveletDelta release];
}

- (void) testAddOperation {
	[_waveletDelta addOperation:[NGTestWaveletOperationForWaveletDelta delta]];
	NSArray *testOperations = [_waveletDelta operations];
	STAssertTrue([testOperations count] == 1, @"Current wavelet delta should have only one operation");
	STAssertEqualObjects([[testOperations objectAtIndex:0] aTestDelta], @"ForTest", @"current operation should has a test delta with 'ForTest'");
}

@end
