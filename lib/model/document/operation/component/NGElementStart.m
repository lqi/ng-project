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

#import "NGElementStart.h"

@implementation NGElementStart

@synthesize type;

- (ProtocolDocumentOperation_Component *) buffer {
	ProtocolDocumentOperation_Component_ElementStart_Builder *elementStartBuilder = [ProtocolDocumentOperation_Component_ElementStart builder];
	[elementStartBuilder setType:self.type];
	ProtocolDocumentOperation_Component_Builder *componentBuilder = [ProtocolDocumentOperation_Component builder];
	[componentBuilder setElementStart:[elementStartBuilder build]];
	return [componentBuilder build];
}

+ (NGElementStart *) elementStartWithType:(NSString *)aType {
	NGElementStart *elementStartInstance = [[[NGElementStart alloc] init] autorelease];
	elementStartInstance.type = aType;
	return elementStartInstance;
}

@end
