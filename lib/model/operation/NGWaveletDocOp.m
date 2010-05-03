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

#import "NGWaveletDocOp.h"

@implementation NGWaveletDocOp

@synthesize documentId;
@synthesize mutateDocument;

+ (NGWaveletDocOp *) documentOperationWithDocumentId:(NGDocumentId *)theDocumentId andMutateDocument:(NGMutateDocument *)theMutateDocument {
	NGWaveletDocOp *waveletDocOpInstance = [[[NGWaveletDocOp alloc] init] autorelease];
	waveletDocOpInstance.documentId = theDocumentId;
	waveletDocOpInstance.mutateDocument = theMutateDocument;
	return waveletDocOpInstance;
}

- (ProtocolWaveletOperation *) buffer {
	ProtocolDocumentOperation_Builder *docOpBuilder = [ProtocolDocumentOperation builder];
	for (id <NGDocOpComponent> component in [self.mutateDocument documentOperations]) {
		[docOpBuilder addComponent:[component buffer]];
	}
	
	ProtocolWaveletOperation_MutateDocument_Builder *mutationDocBuilder = [ProtocolWaveletOperation_MutateDocument builder];
	[mutationDocBuilder setDocumentId:self.documentId];
	[mutationDocBuilder setDocumentOperation:[docOpBuilder build]];
	ProtocolWaveletOperation_Builder *waveletOpBuilder = [ProtocolWaveletOperation builder];
	[waveletOpBuilder setMutateDocument:[mutationDocBuilder build]];
	return [waveletOpBuilder build];
}

@end
