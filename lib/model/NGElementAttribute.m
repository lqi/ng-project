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

#import "NGElementAttribute.h"

@implementation NGElementAttribute

- (id) init {
	if (self = [super init]) {
		_attribtues = [[NSMutableDictionary alloc] init];
	}
	return self;
}

+ (NGElementAttribute *) attributes {
	return [[[NGElementAttribute alloc] init] autorelease];
}

- (void) insertAttribute:(NSString *)key value:(NSString *)value {
	if ([self hasAttribute:key]) {
		// TODO: throw exceptions
	}
	[_attribtues setValue:value forKey:key];
}

- (void) replaceAttribute:(NSString *)key oldValue:(NSString *)oldValue newValue:(NSString *)newValue {
	if (![self hasAttribute:key]) {
		// TODO: throw exceptions
	}
	if (![[_attribtues valueForKey:key] isEqual:oldValue]) {
		// TODO: throw exceptions
	}
	[_attribtues setValue:newValue forKey:key];
}

- (BOOL) hasAttribute:(NSString *)key {
	return [_attribtues valueForKey:key] != nil;
}

- (NSString *) attribute:(NSString *)key {
	if (![self hasAttribute:key]) {
		// TODO: exceptions
	}
	return [_attribtues valueForKey:key];
}

- (void) parseFromKeyValuePairs:(NSArray *)keyValuePairs {
	for (ProtocolDocumentOperation_Component_KeyValuePair *attribute in keyValuePairs) {
		[self insertAttribute:[attribute key] value:[attribute value]];
	}
}

- (void) parseFromKeyValueUpdates:(NSArray *)keyValueUpdates {
	for (ProtocolDocumentOperation_Component_KeyValueUpdate *attribute in keyValueUpdates) {
		if ([attribute hasOldValue]) {
			[self replaceAttribute:[attribute key] oldValue:[attribute oldValue] newValue:[attribute newValue]];
		}
		else {
			[self insertAttribute:[attribute key] value:[attribute newValue]];
		}
	}
}

- (void) dealloc {
	[_attribtues release];
	[super dealloc];
}

@end
