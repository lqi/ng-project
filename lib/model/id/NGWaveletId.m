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

#import "NGWaveletId.h"

@implementation NGWaveletId

@synthesize domain;
@synthesize waveletId;

+ (NGWaveletId *) waveletIdWithDomain:(NSString *)theDomain waveletId:(NSString *)theWaveletId {
	return [[[NGWaveletId alloc] initWithDomain:theDomain waveletId:theWaveletId] autorelease];
}

- (id) initWithDomain:(NSString *)theDomain waveletId:(NSString *)theWaveletId {
	if (self = [super init]) {
		self.domain = theDomain;
		self.waveletId = theWaveletId;
	}
	return self;
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
	NGWaveletId *other = (NGWaveletId *)object;
	return [self.domain isEqual:other.domain] && [self.waveletId isEqual:other.waveletId];
}

@end
