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

#import "NGBufferedDocOpTest.h"

@implementation NGBufferedDocOpTest

- (void) setUp {
}

- (void) tearDown {
}

- (void) testCharacters {
	NSMutableArray *testComponent = [NSMutableArray array];
	[testComponent addObject:[NGCharacters charactersWithCharacters:@"test"]];
	ProtocolDocumentOperation *docOp = [NGBufferedDocOp create:testComponent];
	ProtocolDocumentOperation_Component *docOpComponent = [docOp componentAtIndex:0];
	STAssertTrue([docOpComponent hasCharacters], @"it should has characters");
	STAssertEqualObjects([docOpComponent characters], @"test", @"the characters should be 'test'");
}

- (void) testRetain {
	NSMutableArray *testComponent = [NSMutableArray array];
	[testComponent addObject:[NGRetain retainWithRetainItemCount:1]];
	ProtocolDocumentOperation *docOp = [NGBufferedDocOp create:testComponent];
	ProtocolDocumentOperation_Component *docOpComponent = [docOp componentAtIndex:0];
	STAssertTrue([docOpComponent hasRetainItemCount], @"it should has retains");
	//STAssertEqualObjects([docOpComponent characters], @"test", @"the characters should be 'test'");
}

@end
