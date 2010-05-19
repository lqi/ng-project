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

#import "NGParticipantIdTest.h"

@implementation NGParticipantIdTest

- (void) setUp {
	_participantId = [[NGParticipantId alloc] init];
	_participantId.domain = @"testDomain";
	_participantId.participantId = @"testId";
}

- (void) tearDown {
	[_participantId release];
}

- (void) testDomain {
	STAssertEqualObjects([_participantId domain], @"testDomain", @"domain should be 'testDomain'");
}

- (void) testParticipantId {
	STAssertEqualObjects([_participantId participantId], @"testId", @"participantId should be 'testId'");
}

- (void) testSerialise {
	STAssertEqualObjects([_participantId serialise], @"testId@testDomain", @"serialised participantId should be 'testId@testDomain'");
}

- (void) testEqualsCompareToSameObject {
	STAssertEqualObjects(_participantId, _participantId, @"participantId with samd object should be equal");
}

- (void) testEqualsCompareToNil {
	STAssertFalse([_participantId isEqual:nil], @"participantId cannot equal to a nil object");
}

- (void) testEqualsCompareToDifferentType {
	STAssertFalse([_participantId isEqual:@"NSString"], @"participantId cannot equal to an object with different type");
}

- (void) testEqualsCompareToSameValue {
	NGParticipantId *compareParticipantId = [NGParticipantId participantIdWithDomain:@"testDomain" participantId:@"testId"];
	STAssertEqualObjects(_participantId, compareParticipantId, @"participantId with same domain and id should be equal");
}

- (void) testDeserialise {
	STAssertEqualObjects(_participantId, [NGParticipantId participantIdWithSerialisedParticipantId:@"testId@testDomain"], @"ParticipantId with same domain and id should be equal");
}

@end
