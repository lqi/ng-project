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

+ (NSDictionary *) styleFromElementAttributes:(NGElementAttribute *)elementAttributes andElementAnnotations:(NGElementAnnotation *)elementAnnotations {
	NSMutableDictionary *styleDictionary = [[NSMutableDictionary dictionary] mutableCopy];
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
	[styleDictionary setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
	
	if ([elementAnnotations hasAnnotation:@"style/color"]) {
		NSString *colorString = [elementAnnotations annotation:@"style/color"];
		if ([colorString length] > 0) {
			NSColor *foregroundColor = [self colorFromAnnotationString:colorString];
			[styleDictionary setObject:foregroundColor forKey:NSForegroundColorAttributeName];
		}
	}
	return styleDictionary;
}

+ (NSColor *) colorFromAnnotationString:(NSString *)annotationString {
	NSString *pString = [annotationString substringWithRange:NSMakeRange(4, [annotationString length] - 5)];
	NSArray *colorArray = [pString componentsSeparatedByString:@", "];
	return [NSColor colorWithCalibratedRed:[self floatValueFromColorString:[colorArray objectAtIndex:0]] green:[self floatValueFromColorString:[colorArray objectAtIndex:1]] blue:[self floatValueFromColorString:[colorArray objectAtIndex:2]] alpha:1.0f];
}
			
+ (float) floatValueFromColorString:(NSString *)colorString {
	float value = [colorString floatValue];
	return (value + 1.0f) / 256.0f;
}

@end
