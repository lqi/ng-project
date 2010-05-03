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

#import "NGIdConstant.h"

@implementation NGIdConstant

+ (NSString *) TOKEN_SEPARATOR {
	return @"+";
}

+ (NSString *) WAVE_URI_SCHEME; {
	return @"wave";
}

+ (NSString *) WAVE_PREFIX {
	return @"w";
}

+ (NSString *) CONVERSATION_WAVELET_PREFIX {
	return @"conv";
}

+ (NSString *) USER_DATA_WAVELET_PREFIX {
	return @"user";
}

+ (NSString *) BLIP_PREFIX {
	return @"b";
}

+ (NSString *) TAGS_DOC_ID {
	return @"tags";
}

+ (NSString *) CONVERSATION_ROOT_WAVELET {
	return [NSString stringWithFormat:@"%@%@root", [NGIdConstant CONVERSATION_WAVELET_PREFIX], [NGIdConstant TOKEN_SEPARATOR]];
}

@end
