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

#import "NGDocAttributesUpdate.h"

@implementation NGDocAttributesUpdate

- (id) init {
	if (self = [super init]) {
		_attributesUpdateArray = [[NSMutableArray alloc] init];
	}
	return self;
}

- (NGDocAttributesUpdate *) addAttributeWithKey:(NSString *)key andOnlyNewValue:(NSString *)value {
	[_attributesUpdateArray addObject:key];
	[_attributesUpdateArray addObject:[NSNull null]];
	[_attributesUpdateArray addObject:value];
	return self;
}

- (NGDocAttributesUpdate *) addAttributeWithKey:(NSString *)key oldValue:(NSString *)oldValue andNewValue:(NSString *)newValue {
	[_attributesUpdateArray addObject:key];
	[_attributesUpdateArray addObject:oldValue];
	[_attributesUpdateArray addObject:newValue];
	return self;
}

- (NSArray *) keys {
	NSMutableArray *keyArray = [[[NSMutableArray alloc] init] autorelease];
	NSUInteger i, count = [_attributesUpdateArray count];
	for (i = 0; i < count; i += 3) {
		NSString *aKey = [_attributesUpdateArray objectAtIndex:i];
		[keyArray addObject:aKey];
	}
	return [keyArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (BOOL) hasOldValue:(NSString *)key {
	NSInteger indexOfKey = [_attributesUpdateArray indexOfObject:key];
	return ![[_attributesUpdateArray objectAtIndex:(indexOfKey + 1)] isEqual:[NSNull null]];
}

- (NSString *) oldValueForKey:(NSString *)key {
	if (![self hasOldValue:key]) {
		[NSException raise:@"Invalid key when getting old value in NGDocAttributeUpdate" format:@"Key %@ has no old value", key];
	}
	NSInteger indexOfKey = [_attributesUpdateArray indexOfObject:key];
	return [_attributesUpdateArray objectAtIndex:(indexOfKey + 1)];
}

- (NSString *) newValueForKey:(NSString *)key {
	NSInteger indexOfKey = [_attributesUpdateArray indexOfObject:key];
	return [_attributesUpdateArray objectAtIndex:(indexOfKey + 2)];
}

+ (NGDocAttributesUpdate *) emptyAttributesUpdate {
	return [[[NGDocAttributesUpdate alloc] init] autorelease];
}

- (void) dealloc {
	[_attributesUpdateArray release];
	[super dealloc];
}

@end
