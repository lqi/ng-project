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

#import "NGDocAttributes.h"

@implementation NGDocAttributes

- (id) init {
	if (self = [super init]) {
		_attributesDictionary = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (NGDocAttributes *) addAttributeWithKey:(NSString *)key andValue:(NSString *)value {
	[_attributesDictionary setValue:value forKey:key];
	return self;
}

- (NSArray *) keys {
	return [[_attributesDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSString *) attributeForKey:(NSString *)key {
	return [_attributesDictionary valueForKey:key];
}

+ (NGDocAttributes *) emptyAttribute {
	return [[[NGDocAttributes alloc] init] autorelease];
}

- (void) dealloc {
	[_attributesDictionary release];
	[super dealloc];
}

@end
