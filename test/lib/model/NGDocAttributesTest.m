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

#import "NGDocAttributesTest.h"

@implementation NGDocAttributesTest

- (void) setUp {
	_docAttributes = [[NGDocAttributes alloc] init];
}

- (void) tearDown {
	[_docAttributes release];
}

- (void) testEmptyAttribute {
	STAssertTrue([[_docAttributes keys] count] == 0, @"empty attribute should has no key");
}

- (void) testDocAttributes {
	[_docAttributes addAttributeWithKey:@"key2" andValue:@"value2"];
	[_docAttributes addAttributeWithKey:@"key1" andValue:@"value1"];
	NSArray *testAttributesArray = [_docAttributes keys];
	STAssertTrue([testAttributesArray count] == 2, @"this array should has two keys");
	STAssertEqualObjects([testAttributesArray objectAtIndex:0], @"key1", @"first key should be 'key1'");
	STAssertEqualObjects([testAttributesArray objectAtIndex:1], @"key2", @"second key should be 'key2'");
	STAssertEqualObjects([_docAttributes attributeForKey:@"key1"], @"value1", @"value for 'key1' should be 'value1'");
	STAssertEqualObjects([_docAttributes attributeForKey:@"key2"], @"value2", @"value for 'key2' should be 'value2'");
}

@end
