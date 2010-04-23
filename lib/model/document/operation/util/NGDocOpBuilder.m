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

#import "NGDocOpBuilder.h"

@implementation NGDocOpBuilder

- (id) init {
	if (self = [super init]) {
		_docOpComponents = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (NGDocOpBuilder *) builder {
	return [[[NGDocOpBuilder alloc] init] autorelease];
}

- (NGDocOpBuilder *) characters:(NSString *)characters {
	[_docOpComponents addObject:[NGCharacters charactersWithCharacters:characters]];
	return self;
}

- (NGDocOpBuilder *) deleteCharacters:(NSString *)characters {
	[_docOpComponents addObject:[NGDeleteCharacters charactersWithDeleteCharacters:characters]];
	return self;
}

- (NGDocOpBuilder *) elementStart:(NSString *)type withAttributes:(NGDocAttributes *)attributes {
	[_docOpComponents addObject:[NGElementStart elementStartWithType:type andAttributes:attributes]];
	return self;
}

- (NGDocOpBuilder *) elementEnd {
	[_docOpComponents addObject:[NGElementEnd elementEnd]];
	return self;
}

- (NGDocOpBuilder *) deleteElementStart:(NSString *)type {
	[_docOpComponents addObject:[NGDeleteElementStart deleteElementStartWithType:type]];
	return self;
}

- (NGDocOpBuilder *) deleteElementEnd {
	[_docOpComponents addObject:[NGDeleteElementEnd deleteElementEnd]];
	return self;
}

- (NGDocOpBuilder *) retain:(NSInteger)retainItemCount {
	[_docOpComponents addObject:[NGRetain retainWithRetainItemCount:retainItemCount]];
	return self;
}

- (NGDocOpBuilder *) updateAttributes:(NGDocAttributesUpdate *)update {
	[_docOpComponents addObject:[NGUpdateAttributes updateAttributesWithUpdateAttributes:update]];
	return self;
}

- (NGMutateDocument *) build {
	return [NGMutateDocument mutateDocument:_docOpComponents];
}

- (void) dealloc {
	[_docOpComponents release];
	[super dealloc];
}

@end
