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

#import "NGIdGenerator.h"

static NSString *const WEB64_ALPHABET = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

@interface NGIdGenerator()

- (NSString *) next:(int)length;
- (NSString *) generateId:(NSString *)namespace length:(int)bits;
- (NSString *) generateUniqueToken:(int)bits;

@end

@implementation NGIdGenerator

- (id) initWithDomain:(NSString *)domain {
	if (self = [super init]) {
		_domain = domain;
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
	return [NSString stringWithFormat:@"%@%@%@", namespace, [NGIdConstant TOKEN_SEPARATOR], [self generateUniqueToken:bits]];
}

- (NSString *) generateUniqueToken:(int)bits {
	int length = (bits + 5) / 6;
	return [self next:length];
}

- (NGWaveId *) newWaveId {
	return [NGWaveId waveIdWithDomain:_domain waveId:[self generateId:[NGIdConstant WAVE_PREFIX] length:72]];
}

- (NGWaveletId *) newConversationWaveletId {
	return [NGWaveletId waveletIdWithDomain:_domain waveletId:[self generateId:[NGIdConstant CONVERSATION_WAVELET_PREFIX] length:48]];
}

- (NGWaveletId *) newConversationRootWaveletId {
	return [NGWaveletId waveletIdWithDomain:_domain waveletId:[NGIdConstant CONVERSATION_ROOT_WAVELET]];
}

- (NGDocumentId *) newDocumentId {
	return [self generateId:[NGIdConstant BLIP_PREFIX] length:36];
}

@end
