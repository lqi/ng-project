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

#import "NGElementAnnotationUpdate.h"

@implementation NGElementAnnotationUpdate

- (id) init {
	if (self = [super init]) {
		_annotationUpdates = [[NSMutableDictionary alloc] init];
		_annotationEnds = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) parse:(ProtocolDocumentOperation_Component_AnnotationBoundary *)annotationBoundary {
	for (NSString *endKey in [annotationBoundary endList]) {
		[_annotationEnds addObject:endKey];
		if ([[_annotationUpdates allKeys] containsObject:endKey]) {
			[_annotationUpdates removeObjectForKey:endKey];
		}
	}
	for (ProtocolDocumentOperation_Component_KeyValueUpdate *change in [annotationBoundary changeList]) {
		if ([change hasNewValue]) {
			[_annotationUpdates setValue:[change newValue] forKey:[change key]];
			if ([_annotationEnds containsObject:[change key]]) {
				[_annotationEnds removeObject:[change key]];
			}
		}
	}
}

- (NSDictionary *)annotationUpdates {
	return _annotationUpdates;
}

- (NSArray *)annotationEnds {
	return _annotationEnds;
}

- (void) dealloc {
	[_annotationUpdates release];
	[_annotationEnds release];
	[super dealloc];
}

@end
