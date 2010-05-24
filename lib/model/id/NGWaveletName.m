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

#import "NGWaveletName.h"

@implementation NGWaveletName

@synthesize waveId;
@synthesize waveletId;

+ (NGWaveletName *) waveletNameWithWaveId:(NGWaveId *)aWaveId andWaveletId:(NGWaveletId *)aWaveletId {
	return [[[NGWaveletName alloc] initWithWaveId:aWaveId WaveletId:aWaveletId] autorelease];
}

+ (NGWaveletName *) waveletNameWithSerialisedWaveletName:(NSString *)serialisedWaveletName {
	NGWaveletName *waveletNameInstance = [[NGWaveletName alloc] init];
	[waveletNameInstance deserialise:serialisedWaveletName];
	[waveletNameInstance autorelease];
	return waveletNameInstance;
}

- (NSString *)domain {
	return self.waveletId.domain;
}

- (id) initWithWaveId:(NGWaveId *)aWaveId WaveletId:(NGWaveletId *)aWaveletId {
	if (self = [super init]) {
		self.waveId = aWaveId;
		self.waveletId = aWaveletId;
	}
	return self;
}

- (void) deserialise:(NSString *)serialisedWaveletName {
	NSURL *waveUrl = [NSURL URLWithString:serialisedWaveletName];
	assert([[waveUrl scheme] isEqual:@"wave"]);
	NSString *domain = [waveUrl host];
	NSString *path = [waveUrl path];
	NSArray *ids = [path componentsSeparatedByString:@"/"];
	NSString *thisWaveId = [ids objectAtIndex:1];
	NSString *thisWaveletId = [ids objectAtIndex:2];
	self.waveId = [NGWaveId waveIdWithDomain:domain waveId:thisWaveId];
	self.waveletId = [NGWaveletId waveletIdWithDomain:domain waveletId:thisWaveletId];
}

- (NSString *) serialise {
	return [NSString stringWithFormat:@"wave://%@/%@/%@", [self domain], self.waveId.waveId, self.waveletId.waveletId];
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
	NGWaveletName *other = (NGWaveletName *)object;
	return [self.waveId isEqual:other.waveId] && [self.waveletId isEqual:other.waveletId];
}

@end
