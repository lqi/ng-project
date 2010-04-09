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

#import "NGElementAnnotation.h"

@implementation NGElementAnnotation

- (id) init {
	if (self = [super init]) {
		_annotations = [[NSMutableDictionary alloc] init];
	}
	return self;
}

+ (NGElementAnnotation *) annotations {
	return [[[NGElementAnnotation alloc] init] autorelease];
}

- (void) insertAnnotation:(NSString *)key value:(NSString *)value {
	if ([self hasAnnotation:key]) {
		// TODO: throw exceptions
	}
	[_annotations setValue:value forKey:key];
}

- (void) replaceAnnotation:(NSString *)key oldValue:(NSString *)oldValue newValue:(NSString *)newValue {
	if (![self hasAnnotation:key]) {
		// TODO: throw exceptions
	}
	if (![[_annotations valueForKey:key] isEqual:oldValue]) {
		// TODO: throw exceptions
	}
	[_annotations setValue:newValue forKey:key];
}

- (BOOL) hasAnnotation:(NSString *)key {
	return [_annotations valueForKey:key] != nil;
}

- (NSString *) annotation:(NSString *)key {
	if (![self hasAnnotation:key]) {
		// TODO: exceptions
	}
	return [_annotations valueForKey:key];
}

- (void) updateAnnotation:(NSString *)key value:(NSString *)value { // TODO: temporary method
	[_annotations setValue:value forKey:key];
}

- (void) merge:(NGElementAnnotationUpdate *)updates {
	/*
	NSArray *annotationEnds = [updates annotationEnds];
	for (NSString *key in annotationEnds) {
		[_annotations removeObjectForKey:key];
	}
	 */
	NSDictionary *annotationUpdates = [updates annotationUpdates];
	for (NSString *key in annotationUpdates) {
		[self updateAnnotation:key value:[annotationUpdates valueForKey:key]];
	}
}

- (NGElementAnnotation *) copy {
	NGElementAnnotation *newAnnotations = [NGElementAnnotation annotations];
	for (NSString *key in _annotations) {
		[newAnnotations insertAnnotation:key value:[_annotations valueForKey:key]];
	}
	return newAnnotations;
}

- (void) dealloc {
	[_annotations release];
	[super dealloc];
}

@end
