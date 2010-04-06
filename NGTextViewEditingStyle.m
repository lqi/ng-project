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

#import "NGTextViewEditingStyle.h"


@implementation NGTextViewEditingStyle

+ (NSParagraphStyle *) styleFromElementAttributes:(NGElementAttribute *)elementAttributes {
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:NSLeftTextAlignment];
	if ([elementAttributes hasAttribute:@"i"]) {
		int value = [[elementAttributes attribute:@"i"] intValue];
		[paragraphStyle setHeadIndent:(CGFloat) (24 * value)];
		[paragraphStyle setFirstLineHeadIndent:(CGFloat) (24 * value)];
	}
	if ([elementAttributes hasAttribute:@"a"]) {
		NSString *value = [elementAttributes attribute:@"a"];
		if ([value isEqual:@"l"]) {
			[paragraphStyle setAlignment:NSLeftTextAlignment];
		}
		else if ([value isEqual:@"c"]) {
			[paragraphStyle setAlignment:NSCenterTextAlignment];
		}
		else if([value isEqual:@"r"]) {
			[paragraphStyle setAlignment:NSRightTextAlignment];
		}
	}
	return [paragraphStyle copy];
}

@end
