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

#import "NGWaveId.h"

@implementation NGWaveId

@synthesize domain;
@synthesize waveId;

+ (NGWaveId *) waveIdWithDomain:(NSString *)theDomain waveId:(NSString *)theWaveId {
	return [[[NGWaveId alloc] initWithDomain:theDomain waveId:theWaveId] autorelease];
}

+ (NGWaveId *) waveIdWithSerialisedWaveId:(NSString *)serialisedWaveId {
	NGWaveId *waveIdInstance = [[NGWaveId alloc] init];
	[waveIdInstance deserialise:serialisedWaveId];
	[waveIdInstance autorelease];
	return waveIdInstance;
}

- (id) initWithDomain:(NSString *)theDomain waveId:(NSString *)theWaveId {
	if (self = [super init]) {
		self.domain = theDomain;
		self.waveId = theWaveId;
	}
	return self;
}

- (NSString *) serialise {
	return [NSString stringWithFormat:@"%@!%@", self.domain, self.waveId];
}

- (void) deserialise:(NSString *)serialisedWaveId {
	NSArray *parts = [serialisedWaveId componentsSeparatedByString:@"!"];
	NSAssert([parts count] == 2, @"WaveId must be in the form of <domain>!<id>");
	self.domain = [parts objectAtIndex:0];
	self.waveId = [parts objectAtIndex:1];
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
	NGWaveId *other = (NGWaveId *)object;
	return [self.domain isEqual:other.domain] && [self.waveId isEqual:other.waveId];
}

@end
