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

#import "NGRandomIdGenerator.h"

static NSString *const TOKEN_SEPARATOR = @"+";
static NSString *const WAVE_URI_SCHEME = @"wave";
static NSString *const WAVE_PREFIX = @"w";
static NSString *const BLIP_PREFIX = @"b";
static NSString *const CONVERSATION_WAVELET_PREFIX = @"conv";
static NSString *const CONVERSATION_ROOT_WAVELET = @"conv+root";

static NSString *const WEB64_ALPHABET = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

@interface NGRandomIdGenerator()

- (NSString *) next:(int)length;
- (NSString *) generateId:(NSString *)namespace length:(int)bits;
- (NSString *) generateUniqueToken:(int)bits;

@end

@implementation NGRandomIdGenerator

- (id) initWithDomain:(NSString *)domain {
	if (self = [super init]) {
		domain_ = domain;
	}
	return self;
}

- (NSString *) next:(int)length {
	NSMutableString *result = [[NSMutableString alloc] init];
	int bits = 0;
	int bitCount = 0;
	while ([result length] < length) {
		if (bitCount < 6) {
			bits = arc4random();
			bitCount = 32;
		}
		NSRange oneBit = {bits & 0x3F, 1};
		[result appendString:[WEB64_ALPHABET substringWithRange:oneBit]];
		bits >>= 6;
		bitCount -= 6;
	}
	return result;
}

- (NSString *) generateId:(NSString *)namespace length:(int)bits {
	NSMutableString *result = [[NSMutableString alloc] init];
	[result appendString:namespace];
	[result appendString:TOKEN_SEPARATOR];
	[result appendString:[self generateUniqueToken:bits]];
	return result;
}

- (NSString *) generateUniqueToken:(int)bits {
	int length = (bits + 5) / 6;
	return [self next:length];
}

- (NGWaveId *) newWaveId {
	return [[NGWaveId alloc] initWithDomain:domain_ waveId:[self generateId:WAVE_PREFIX length:72]];
}

- (NGWaveletId *) newConversationRootWaveletId {
	return [[NGWaveletId alloc] initWithDomain:domain_ waveletId:CONVERSATION_ROOT_WAVELET];
}

@end
