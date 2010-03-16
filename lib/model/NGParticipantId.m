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

+ (NGParticipantId *) participantIdWithDomain:(NSString *)domain participantId:(NSString *)participantId {
	return [[[NGParticipantId alloc] initWithDomain:domain participantId:participantId] autorelease];
}

+ (NGParticipantId *) participantIdWithParticipantIdAtDomain:(NSString *)stringParticipantIdAtDomain {
	return [[[NGParticipantId alloc] initWithParticipantIdAtDomain:stringParticipantIdAtDomain] autorelease];
}

- (id) initWithDomain:(NSString *)domain participantId:(NSString *)participantId {
	if (self = [super init]) {
		_domain = domain;
		_participantId = participantId;
	}
	return self;
}

- (id) initWithParticipantIdAtDomain:(NSString *)stringParticipantIdAtDomain {
	if (self = [super init]) {
		[self parse:stringParticipantIdAtDomain];
	}
	return self;
}

- (NSString *) domain {
	return _domain;
}

- (NSString *) participantId {
	return _participantId;
}

- (NSString *) participantIdAtDomain {
	return [NSString stringWithFormat:@"%@@%@", _participantId, _domain];
}

- (void) parse:(NSString *)stringParticipantIdAtDomain {
	NSArray *splitParticipantIdFromDomain = [stringParticipantIdAtDomain componentsSeparatedByString:@"@"];
	assert([splitParticipantIdFromDomain count] == 2);
	_participantId = [splitParticipantIdFromDomain objectAtIndex:0];
	_domain = [splitParticipantIdFromDomain objectAtIndex:1];
}

- (BOOL) isEqual:(id)object {
	if (![[[self class] description] isEqual:[[object class] description]]) {
		return NO;
	}
	return [[self domain] isEqual:[object domain]] && [[self participantId] isEqual:[object participantId]];
}

@end
