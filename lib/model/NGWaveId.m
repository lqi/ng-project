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

- (id) initWithDomain:(NSString *)domain waveId:(NSString *)waveId {
	if (self = [super init]) {
		_domain = domain;
		_waveId = waveId;
	}
	return self;
}

- (NSString *) domain {
	return _domain;
}

- (NSString *) waveId {
	return _waveId;
}

- (BOOL) isEqual:(id)object {
	if (![[[self class] description] isEqual:[[object class] description]]) {
		return NO;
	}
	return [[self domain] isEqual:[object domain]] && [[self waveId] isEqual:[object waveId]];
}

@end