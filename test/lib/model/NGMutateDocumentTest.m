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

#import "NGMutateDocumentTest.h"

@interface NGTestDocOpComponentForMutateDocument : NSObject <NGDocOpComponent> {
}

- (NSString *) aTestType;
+ (NGTestDocOpComponentForMutateDocument *) aTestComponent;

@end

@implementation NGTestDocOpComponentForMutateDocument

- (ProtocolDocumentOperation_Component *) buffer {
	ProtocolDocumentOperation_Component_Builder *componentBuilder = [ProtocolDocumentOperation_Component builder];
	return [componentBuilder build];
}

- (NSString *) aTestType {
	return @"ForTest";
}

+ (NGTestDocOpComponentForMutateDocument *) aTestComponent {
	return [[[NGTestDocOpComponentForMutateDocument alloc] init] autorelease];
}

@end

@implementation NGMutateDocumentTest

- (void) setUp {
	_mutateDocument = [[NGMutateDocument alloc] init];
}

- (void) tearDown {
	[_mutateDocument release];
}

- (void) testAddOperation {
	[_mutateDocument addOperation:[NGTestDocOpComponentForMutateDocument aTestComponent]];
	NSArray *testOperationComponents = [_mutateDocument documentOperations];
	STAssertTrue([testOperationComponents count] == 1, @"Current mutate document should have only one operation");
	STAssertEqualObjects([[testOperationComponents objectAtIndex:0] aTestType], @"ForTest", @"current component should has a test type with 'ForTest'");
}

@end
