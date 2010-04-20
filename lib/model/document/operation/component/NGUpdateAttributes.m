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

#import "NGUpdateAttributes.h"

@implementation NGUpdateAttributes

@synthesize update;

- (ProtocolDocumentOperation_Component *) buffer {
	ProtocolDocumentOperation_Component_UpdateAttributes_Builder *updateAttributesBuilder = [ProtocolDocumentOperation_Component_UpdateAttributes builder];
	for (NSString *key in [self.update keys]) {
		ProtocolDocumentOperation_Component_KeyValueUpdate_Builder *keyValueUpdateBuilder = [ProtocolDocumentOperation_Component_KeyValueUpdate builder];
		[keyValueUpdateBuilder setKey:key];
		if ([self.update hasOldValue:key]) {
			[keyValueUpdateBuilder setOldValue:[self.update oldValueForKey:key]];
		}
		[keyValueUpdateBuilder setNewValue:[self.update newValueForKey:key]];
		[updateAttributesBuilder addAttributeUpdate:[keyValueUpdateBuilder build]];
	}
	ProtocolDocumentOperation_Component_Builder *componentBuilder = [ProtocolDocumentOperation_Component builder];
	[componentBuilder setUpdateAttributes:[updateAttributesBuilder build]];
	return [componentBuilder build];
}

+ (NGUpdateAttributes *) updateAttributesWithUpdateAttributes:(NGDocAttributesUpdate *)updateAttributes {
	NGUpdateAttributes *updateInstance = [[[NGUpdateAttributes alloc] init] autorelease];
	updateInstance.update = updateAttributes;
	return updateInstance;
}

@end
