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

#import "NGParticipantId.h"

@implementation NGParticipantId

@synthesize participantId;
@synthesize domain;

+ (NGParticipantId *) participantIdWithDomain:(NSString *)theDomain participantId:(NSString *)theParticipantId {
	return [[[NGParticipantId alloc] initWithDomain:theDomain participantId:theParticipantId] autorelease];
}

+ (NGParticipantId *) participantIdWithSerialisedParticipantId:(NSString *)serialisedParticipantId {
	NGParticipantId *participantIdInstance = [[NGParticipantId alloc] init];
	[participantIdInstance deserialise:serialisedParticipantId];
	[participantIdInstance autorelease];
	return participantIdInstance;
}

- (id) initWithDomain:(NSString *)theDomain participantId:(NSString *)theParticipantId {
	if (self = [super init]) {
		self.domain = theDomain;
		self.participantId = theParticipantId;
	}
	return self;
}

- (NSString *) serialise {
	return [NSString stringWithFormat:@"%@@%@", self.participantId, self.domain];
}

- (void) deserialise:(NSString *)serialisedParticipantId {
	if ([serialisedParticipantId isEqual:[NGIdConstant DIGEST_AUTHOR]]) {
		self.participantId = serialisedParticipantId;
		self.domain = @"waveserver";
	}
	else {
		NSArray *splitParticipantIdFromDomain = [serialisedParticipantId componentsSeparatedByString:@"@"];
		assert([splitParticipantIdFromDomain count] == 2);
		self.participantId = [splitParticipantIdFromDomain objectAtIndex:0];
		self.domain = [splitParticipantIdFromDomain objectAtIndex:1];
	}
}

- (BOOL) isEqual:(id)object {
	if (object == nil) {
		return NO;
	}
	if (self == object) {
		return YES;
	}
	if (![[[self class] description] isEqual:[[object class] description]]) {
		return NO;
	}
	NGParticipantId *other = (NGParticipantId *)object;
	return [self.domain isEqual:other.domain] && [self.participantId isEqual:other.participantId];
}

@end
