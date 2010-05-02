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

#import "NGDocAttributesUpdateTest.h"

@implementation NGDocAttributesUpdateTest

- (void) setUp {
	_docAttributesUpdate = [[NGDocAttributesUpdate alloc] init];
}

- (void) tearDown {
	[_docAttributesUpdate release];
}

- (void) testEmptyAttributesUpdate {
	STAssertTrue([[_docAttributesUpdate keys] count] == 0, @"empty attribute should has no key");
}

- (void) testAddAttributeWithOldKey {
	[_docAttributesUpdate addAttributeWithKey:@"aKey" oldValue:@"anOldValue" andNewValue:@"aBrandNewValue"];
	STAssertTrue([[_docAttributesUpdate keys] count] == 1, @"only one attributeUpdate here");
	STAssertEqualObjects([[_docAttributesUpdate keys] objectAtIndex:0], @"aKey", @"the key should be 'aKey'");
	STAssertTrue([_docAttributesUpdate hasOldValue:@"aKey"], @"the key should has old value");
	STAssertEqualObjects([_docAttributesUpdate oldValueForKey:@"aKey"], @"anOldValue", @"the old value should be 'anOldValue'");
	STAssertEqualObjects([_docAttributesUpdate newValueForKey:@"aKey"], @"aBrandNewValue", @"the new value should be 'aBrandNewValue'");
}

- (void) testAddAttributeWithoutOldKey {
	[_docAttributesUpdate addAttributeWithKey:@"aKey" andOnlyNewValue:@"onlyNewValue"];
	STAssertTrue([[_docAttributesUpdate keys] count] == 1, @"only one attributeUpdate here");
	STAssertEqualObjects([[_docAttributesUpdate keys] objectAtIndex:0], @"aKey", @"the key should be 'aKey'");
	STAssertFalse([_docAttributesUpdate hasOldValue:@"aKey"], @"the key should has no old value");
	STAssertThrowsSpecificNamed([_docAttributesUpdate oldValueForKey:@"aKey"], NSException, @"Invalid key when getting old value in NGDocAttributeUpdate", @"should throw invalid key exception");
	STAssertEqualObjects([_docAttributesUpdate newValueForKey:@"aKey"], @"onlyNewValue", @"the new value should be 'onlyNewValue'");
}

- (void) testAddAttributeWithMoreKeys {
	[_docAttributesUpdate addAttributeWithKey:@"key2" andOnlyNewValue:@"value2"];
	[_docAttributesUpdate addAttributeWithKey:@"key1" oldValue:@"oldValue" andNewValue:@"value1"];
	STAssertTrue([[_docAttributesUpdate keys] count] == 2, @"there should be two attributesUpdate");
}

// TODO: more test cases can be written, like add an attribute with an existing key

@end
