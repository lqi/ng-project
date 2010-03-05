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

#import "NGRpc.h"

@implementation NGRpc

+ (void)send:(PBGeneratedMessage *)message viaOutputStream:(PBCodedOutputStream *)stream sequenceNo:(long)sequenceNo {
	NSMutableString *messageType = [[NSMutableString alloc] initWithString:@"waveserver."];
	[messageType appendString:[message className]];
	int32_t size = computeInt32SizeNoTag(sequenceNo) + computeStringSizeNoTag(messageType) + computeMessageSizeNoTag(message);
	[stream writeRawLittleEndian32:size];
	[stream writeInt64NoTag:sequenceNo];
	[stream writeStringNoTag:messageType];
	[stream writeMessageNoTag:message];
	[stream flush];
}

@end
