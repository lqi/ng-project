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

#import "NGWaveName.h"

@implementation NGWaveName

@synthesize waveId;
@synthesize waveletId;

- (NSString *)domain {
	return [[self waveletId] domain];
}

- (id) initWithWaveId:(NGWaveId *)aWaveId WaveletId:(NGWaveletId *)aWaveletId {
	if (self = [super init]) {
		[self setWaveId:aWaveId];
		[self setWaveletId:aWaveletId];
	}
	return self;
}

- (id) initWithString:(NSString *)stringWaveUrl {
	if (self = [super init]) {
		[self parse:stringWaveUrl];
	}
	return self;
}

- (void) parse:(NSString *)stringWaveUrl {
	NSURL *waveUrl = [NSURL URLWithString:stringWaveUrl];
	assert([[waveUrl scheme] isEqual:@"wave"]);
	NSString *domain = [waveUrl host];
	NSString *path = [waveUrl path];
	NSArray *ids = [path componentsSeparatedByString:@"/"];
	NSString *thisWaveId = [ids objectAtIndex:1];
	NSString *thisWaveletId = [ids objectAtIndex:2];
	[self setWaveId:[NGWaveId waveIdWithDomain:domain waveId:thisWaveId]];
	[self setWaveletId:[NGWaveletId waveletIdWithDomain:domain waveletId:thisWaveletId]];
}

- (NSString *) url {
	return [NSString stringWithFormat:@"wave://%@/%@/%@", [self domain], [[self waveId] waveId], [[self waveletId] waveletId]];
}

@end
