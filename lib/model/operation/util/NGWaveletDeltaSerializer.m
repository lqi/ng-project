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

#import "NGWaveletDeltaSerializer.h"

@implementation NGWaveletDeltaSerializer

+ (ProtocolWaveletDelta *) bufferedWaveletDelta:(NGWaveletDelta *)waveletDelta withVersion:(NGHashedVersion *)version {
	ProtocolHashedVersion_Builder *hashedVersionBuilder = [ProtocolHashedVersion builder];
	[hashedVersionBuilder setVersion:version.version];
	[hashedVersionBuilder setHistoryHash:version.historyHash];
	
	ProtocolWaveletDelta_Builder *deltaBuilder = [ProtocolWaveletDelta builder];
	[deltaBuilder setAuthor:[waveletDelta.author participantIdAtDomain]];
	for (id <NGWaveletOperation> operation in [waveletDelta operations]) {
		[deltaBuilder addOperation:[operation buffer]];
	}
	[deltaBuilder setHashedVersion:[hashedVersionBuilder build]];
	return [deltaBuilder build];
}

@end
