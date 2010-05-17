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

#import "NGClientRpcCallback.h"

@implementation NGClientRpcCallback

+ (NGClientRpcCallback *) rpcCallbackWithApplication:(id <NGClientRpcDelegate>)application {
	return [[[NGClientRpcCallback alloc] initWithApplication:application] autorelease];
}

- (id) initWithApplication:(id <NGClientRpcDelegate>)application {
	if (self = [super init]) {
		_application = application;
	}
	return self;
}

- (void) onSuccess:(PBGeneratedMessage *)message {
	NSString *messageType = [[message class] description];
	if ([messageType isEqual:@"ProtocolWaveletUpdate"]) {
		ProtocolWaveletUpdate *waveletUpdate = (ProtocolWaveletUpdate *)message;
		NGWaveletName *waveName = [NGWaveletName waveNameWithString:[waveletUpdate waveletName]];
		NGHashedVersion *hashedVersion = [NGHashedVersion hashedVersion:[[waveletUpdate resultingVersion] version] withHistoryHash:[[waveletUpdate resultingVersion] historyHash]];
		[_application rpcCallbackUpdateHashedVersion:hashedVersion forWavelet:waveName];
		for (ProtocolWaveletDelta *waveletDelta in [waveletUpdate appliedDeltaList]) {
			NGParticipantId *authorId = [NGParticipantId participantIdWithParticipantIdAtDomain:[waveletDelta author]];
			for (ProtocolWaveletOperation *waveletOperation in [waveletDelta operationList]) {
				if ([waveletOperation hasAddParticipant]) {
					NGParticipantId *addParticipantId = [NGParticipantId participantIdWithParticipantIdAtDomain:[waveletOperation addParticipant]];
					[_application rpcCallbackAddParticipant:addParticipantId fromAuthor:authorId forWavelet:waveName];
				}
				if ([waveletOperation hasRemoveParticipant]) {
					NGParticipantId *removeParticipantId = [NGParticipantId participantIdWithParticipantIdAtDomain:[waveletOperation removeParticipant]];
					[_application rpcCallbackRemoveParticipant:removeParticipantId fromAuthor:authorId forWavelet:waveName];
				}
				if ([waveletOperation hasMutateDocument]) {
					[_application rpcCallbackWaveletDocument:[waveletOperation mutateDocument] fromAuthor:authorId forWavelet:waveName];
				}
				if ([waveletOperation hasNoOp]) {
					[_application rpcCallbackNoOperationFromAuthor:authorId forWavelet:waveName];
				}
			}
		}
	}
	else if ([messageType isEqual:@"ProtocolSubmitResponse"]) {
		[_application rpcCallbackSubmitResponse];
	}
	else {
		[_application rpcCallbackUnknownMessage:messageType message:message];
	}

}

- (void) onFailure:(NSString *)errorText {
	[_application rpcCallbackFailure:errorText];
}

@end
