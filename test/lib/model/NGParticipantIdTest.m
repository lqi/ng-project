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
	_participantId = [[NGParticipantId alloc] initWithDomain:@"testDomain" participantId:@"testId"];
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

- (void) testParticipantIdAtDomain {
	STAssertEqualObjects([_participantId participantIdAtDomain], @"testId@testDomain", @"participantIdAtDomain should be 'testId@testDomain'");
}

- (void) testEquals {
	NGParticipantId *compareParticipantId = [[NGParticipantId alloc] initWithDomain:@"testDomain" participantId:@"testId"];
	STAssertEqualObjects(_participantId, compareParticipantId, @"ParticipantId with same domain and id should be equal");
	[compareParticipantId release];
}

@end
