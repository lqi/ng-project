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

+ (void) send:(NGRpcMessage *)rpcMessage viaOutputStream:(PBCodedOutputStream *)stream {
	NSMutableString *messageType = [[NSMutableString alloc] initWithString:@"waveserver."];
	[messageType appendString:[[[rpcMessage message] class] description]];
	int32_t size = computeInt32SizeNoTag([rpcMessage sequenceNo]) + computeStringSizeNoTag(messageType) + computeMessageSizeNoTag([rpcMessage message]);
	@synchronized (stream) {
		[stream writeRawLittleEndian32:size];
		[stream writeInt64NoTag:[rpcMessage sequenceNo]];
		[stream writeStringNoTag:messageType];
		[stream writeMessageNoTag:[rpcMessage message]];
		[stream flush];
	}
}

+ (NGRpcMessage *) receive:(PBCodedInputStream *)stream {
	NGRpcMessage *returnMessage = [[[NGRpcMessage alloc] init] autorelease];
	
	@synchronized (stream) {
		/* int32_t size = */[stream readRawLittleEndian32];
		long seqNo = [stream readInt64];
		NSMutableString *messageType = [[NSMutableString alloc] initWithString:[stream readString]];
		NSString *stringToBeDeleted = @"waveserver.";
		NSRange rangeToBeDeleted = {0, [stringToBeDeleted length]};
		[messageType deleteCharactersInRange:rangeToBeDeleted];
		[messageType appendString:@"_Builder"];
		PBGeneratedMessage_Builder *messageBuilder = [[NSClassFromString(messageType) alloc] init];
		if (messageBuilder == nil) {
			// do nothing at the moment
		}
		else {
			[stream readMessage:messageBuilder extensionRegistry:[PBExtensionRegistry emptyRegistry]];
			[returnMessage setSequenceNo:seqNo];
			[returnMessage setMessage:[messageBuilder build]];
		}
	}
	
	return returnMessage;
}

@end
