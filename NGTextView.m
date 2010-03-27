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

#import "NGTextView.h"

@implementation NGTextView

@synthesize waveletVersion;
@synthesize waveletHistoryHash;

- (void)openWithNetwork:(NGNetwork *)network WaveId:(NGWaveId *)waveId waveletId:(NGWaveletId *)waveletId participantId:(NGParticipantId *)participantId sequenceNo:(long)seqNo {
	_waveId = [waveId retain];
	_waveletId = [waveletId retain];
	_participantId = [participantId retain];
	_network = [network retain];
	_seqNo = seqNo;
	_waveRpcItems = [[NSMutableArray alloc] init];
}

- (void)close {
	[_waveRpcItems release];
	[_waveId release];
	[_waveletId release];
	[_participantId release];
	[_network release];
	_seqNo = 0;
	self.waveletVersion = 0;
	self.waveletHistoryHash = [NSData data];
	[self setString:@""];
}

- (long)seqNo {
	return _seqNo++;
}

- (NSString *)openWaveId {
	return [_waveId waveId];
}

- (void)keyDown:(NSEvent *)theEvent {
	[self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void)insertTab:(id)sender {
	NSLog(@"TAB");
}

- (void)insertText:(id)characters {
	[self insertCharacters:characters caretOffset:[self caretOffset]];
}

- (void)insertLineBreak:(id)sender {
	[self insertLineMutationDocument:[self caretOffset]];
}

- (void)insertNewline:(id)sender {
	[self insertLineMutationDocument:[self caretOffset]];
}

- (void)deleteBackward:(id)sender {
	int caretOffset = [self caretOffset];
	
	if (caretOffset == 0) {
		NSLog(@"Reach the very beginning!");
		return;
	}
	
	[self deleteCurrentElement:(caretOffset - 1)];
}

- (void)deleteForward:(id)sender {
	int caretOffset = [self caretOffset];
	
	if (caretOffset == [self textLength]) {
		NSLog(@"Reach the very ending!");
		return;
	}
	
	[self deleteCurrentElement:caretOffset];
}

- (NSInteger)caretOffset {
	return [[[self selectedRanges] objectAtIndex:0] rangeValue].location;
}

- (NSInteger)textLength {
	return [[self string] length];
}

- (NSInteger)positionOffset:(int)caretOffset {
	if (caretOffset == 0) {
		return 5; // TODO: Hard define this, before the first element, there should be <contributor></contributor><body><line></line>
	}
	
	int currentCaretOffset = 0;
	int returnPosition = 0;
	while (returnPosition < [self positionLength]) {
		NSString *thisItem = [_waveRpcItems objectAtIndex:returnPosition];
		if ([thisItem isEqual:@"contributorStart"]) {
			returnPosition += 2;
		}
		else if ([thisItem isEqual:@"bodyStart"]) {
			returnPosition++;
		}
		else if ([thisItem isEqual:@"lineStart"]) {
			BOOL firstLine = YES;
			for (int j = 0; j < returnPosition; j++) {
				if ([[_waveRpcItems objectAtIndex:j] isEqual:@"lineStart"]) {
					firstLine = NO;
					break;
				}
			}
			if (!firstLine) {
				currentCaretOffset++;
			}
			returnPosition += 2;
		}
		else if ([thisItem isEqual:@"character"]) {
			currentCaretOffset++;
			returnPosition++;
		}
		
		if (currentCaretOffset == caretOffset) {
			break;
		}
	}
	return returnPosition;
}

- (NSInteger)positionLength {
	return [_waveRpcItems count];
}

- (void)insertCharacters:(NSString *)characters caretOffset:(int)caretOffset {
	int retainItemCount = [self positionOffset:caretOffset];
	ProtocolDocumentOperation_Builder *blipDocOpBuilder = [ProtocolDocumentOperation builder];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setRetainItemCount:retainItemCount] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setCharacters:characters] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setRetainItemCount:([self positionLength] - retainItemCount)] build]]; 
	
	[self sendDocumentOperation:[blipDocOpBuilder build]];
}

- (void)insertLineMutationDocument:(int)caretOffset {
	ProtocolDocumentOperation_Component_ElementStart_Builder *blipLineElementStartBuilder = [ProtocolDocumentOperation_Component_ElementStart builder];
	[blipLineElementStartBuilder setType:@"line"];
	
	int retainItemCount = [self positionOffset:caretOffset];
	ProtocolDocumentOperation_Builder *blipDocOpBuilder = [ProtocolDocumentOperation builder];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setRetainItemCount:retainItemCount] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementStart:[blipLineElementStartBuilder build]] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setElementEnd:YES] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setRetainItemCount:([self positionLength] - retainItemCount)] build]]; 
	
	[self sendDocumentOperation:[blipDocOpBuilder build]];
}

- (void)deleteCurrentElement:(int)caretOffset {
	int positionOffset = [self positionOffset:caretOffset];
	NSString *thisItem = [_waveRpcItems objectAtIndex:positionOffset];
	if ([thisItem isEqual:@"character"]) {
		NSString *charactersToBeDeleted = [[self string] substringWithRange:NSMakeRange(caretOffset, 1)];
		ProtocolDocumentOperation_Builder *blipDocOpBuilder = [ProtocolDocumentOperation builder];
		[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setRetainItemCount:positionOffset] build]];
		[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setDeleteCharacters:charactersToBeDeleted] build]];
		[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setRetainItemCount:([self positionLength] - positionOffset - [charactersToBeDeleted length])] build]]; 
		
		[self sendDocumentOperation:[blipDocOpBuilder build]];
	}
	else if ([thisItem isEqual:@"lineStart"]) {
		ProtocolDocumentOperation_Component_ElementStart_Builder *blipLineElementStartBuilder = [ProtocolDocumentOperation_Component_ElementStart builder];
		[blipLineElementStartBuilder setType:@"line"];
		
		ProtocolDocumentOperation_Builder *blipDocOpBuilder = [ProtocolDocumentOperation builder];
		[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setRetainItemCount:positionOffset] build]];
		[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setDeleteElementStart:[blipLineElementStartBuilder build]] build]];
		[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setDeleteElementEnd:YES] build]];
		[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setRetainItemCount:([self positionLength] - positionOffset - 2)] build]]; 
		
		[self sendDocumentOperation:[blipDocOpBuilder build]];
	}
}

- (void)sendDocumentOperation:(ProtocolDocumentOperation *)docOp {
	NGWaveUrl *waveUrl = [[NGWaveUrl alloc] initWithWaveId:_waveId WaveletId:_waveletId];
	NSString *waveName = [waveUrl stringValue];
	[waveUrl release];
	
	ProtocolSubmitRequest_Builder *submitRequestBuilder = [ProtocolSubmitRequest builder];
	[submitRequestBuilder setWaveletName:waveName];
	
	ProtocolWaveletDelta_Builder *deltaBuilder = [ProtocolWaveletDelta builder];
	[deltaBuilder setAuthor:[_participantId participantIdAtDomain]];
	
	ProtocolWaveletOperation_MutateDocument_Builder *blipMutateDocBuilder = [ProtocolWaveletOperation_MutateDocument builder];
	[blipMutateDocBuilder setDocumentId:_blipId];
	[blipMutateDocBuilder setDocumentOperation:docOp];
	ProtocolWaveletOperation_Builder *blipOpBuilder = [ProtocolWaveletOperation builder];
	[blipOpBuilder setMutateDocument:[blipMutateDocBuilder build]];
	[deltaBuilder addOperation:[blipOpBuilder build]];
	
	ProtocolHashedVersion_Builder *hashedVersionBuilder = [ProtocolHashedVersion builder];
	[hashedVersionBuilder setVersion:self.waveletVersion];
	[hashedVersionBuilder setHistoryHash:self.waveletHistoryHash];
	[deltaBuilder setHashedVersion:[hashedVersionBuilder build]];
	
	[submitRequestBuilder setDelta:[deltaBuilder build]];
	
	[NGRpc send:[NGRpcMessage rpcMessage:[submitRequestBuilder build] sequenceNo:[self seqNo]] viaOutputStream:[_network pbOutputStream]];
}

- (void) apply:(ProtocolWaveletOperation_MutateDocument *)mutateDocument {
	NSTextStorage *textStorage = [self textStorage];
	NSMutableArray *elementStack = [[NSMutableArray alloc] init];
	int cursor = 0;
	int rpcPosition = 0;
	[textStorage beginEditing];
	for (ProtocolDocumentOperation_Component *comp in [[mutateDocument documentOperation] componentList]) {
		if ([comp hasCharacters]) {
			NSString *chars = [comp characters];
			[textStorage replaceCharactersInRange:NSMakeRange(cursor, 0) withString:chars];
			cursor += [chars length];
			for (int i = 0; i < [chars length]; i++) {
				[_waveRpcItems insertObject:@"character" atIndex:rpcPosition++];
			}
		}
		if ([comp hasDeleteCharacters]) {
			NSString *chars = [comp deleteCharacters];
			// TODO: There should be validation before deleting the characters
			[textStorage deleteCharactersInRange:NSMakeRange(cursor, [chars length])];
			for (int i = 0; i < [chars length]; i++) {
				[_waveRpcItems removeObjectAtIndex:rpcPosition];
			}
		}
		if ([comp hasRetainItemCount]) {
			rpcPosition = [comp retainItemCount];
			cursor = 0;
			for (int i = 0; i < rpcPosition; i++) {
				NSString *thisItem = [_waveRpcItems objectAtIndex:i];
				if ([thisItem isEqual:@"lineStart"]) {
					BOOL firstLine = YES;
					for (int j = 0; j < i; j++) {
						if ([[_waveRpcItems objectAtIndex:j] isEqual:@"lineStart"]) {
							firstLine = NO;
							break;
						}
					}
					if (!firstLine) {
						cursor++;
					}
				}
				if ([thisItem isEqual:@"character"]) {
					cursor++;
				}
			}
		}
		if ([comp hasElementStart]) {
			ProtocolDocumentOperation_Component_ElementStart *elementStart = [comp elementStart];
			NSString *elementType = [elementStart type];
			[elementStack addObject:elementType];
			if ([elementType isEqual:@"conversation"]) {
				// TODO: ignore at the moment as there is only one blip
			}
			else if ([elementType isEqual:@"blip"]) {
				ProtocolDocumentOperation_Component_KeyValuePair *blipIdAttribute = [elementStart attributeAtIndex:0];
				NSAssert([[blipIdAttribute key] isEqual:@"id"], @"blip id attribute should has the key of id");
				_blipId = [blipIdAttribute value];
			}
			else if ([elementType isEqual:@"contributor"]) {
				[_waveRpcItems insertObject:@"contributorStart" atIndex:rpcPosition++];
			}
			else if ([elementType isEqual:@"body"]) {
				[_waveRpcItems insertObject:@"bodyStart" atIndex:rpcPosition++];
			}
			else if ([elementType isEqual:@"line"]) {
				BOOL firstLine = YES;
				for (int i = 0; i < rpcPosition; i++) {
					if ([[_waveRpcItems objectAtIndex:i] isEqual:@"lineStart"]) {
						firstLine = NO;
						break;
					}
				}
				if (!firstLine) {
					[textStorage replaceCharactersInRange:NSMakeRange(cursor, 0) withString:@"\n"];
					cursor++;
				}
				[_waveRpcItems insertObject:@"lineStart" atIndex:rpcPosition++];
			}
		}
		if ([comp hasElementEnd]) {
			if ([comp elementEnd]) {
				NSString *elementType = [[elementStack lastObject] retain];
				[elementStack removeLastObject];
				if ([elementType isEqual:@"blip"] || [elementType isEqual:@"conversation"]) {
					// TODO: ignore at the moment as there is only one blip
				}
				else {
					[_waveRpcItems insertObject:@"elementEnd" atIndex:rpcPosition++];
				}
				[elementType release];
			}
		}
		if ([comp hasDeleteElementStart]) {
			ProtocolDocumentOperation_Component_ElementStart *deleteElementStart = [comp deleteElementStart];
			NSString *elementType = [deleteElementStart type];
			if ([elementType isEqual:@"line"]) {
				NSAssert([[_waveRpcItems objectAtIndex:rpcPosition] isEqual:@"lineStart"], @"Technically, this element should be lineStart");
				BOOL firstLine = YES;
				for (int i = 0; i < rpcPosition; i++) {
					if ([[_waveRpcItems objectAtIndex:i] isEqual:@"lineStart"]) {
						firstLine = NO;
						break;
					}
				}
				if (!firstLine) {
					[textStorage deleteCharactersInRange:NSMakeRange(cursor, 1)];
				}
				[_waveRpcItems removeObjectAtIndex:rpcPosition];
			}
			else {
				// TODO: at the moment, only lineBreak could be deleted
			}
		}
		if ([comp hasDeleteElementEnd]) {
			if ([comp deleteElementEnd]) {
				NSAssert([[_waveRpcItems objectAtIndex:rpcPosition] isEqual:@"elementEnd"], @"Technically, this element should be elementEnd for a lineStart");
				[_waveRpcItems removeObjectAtIndex:rpcPosition];
			}
		}
	}
	[textStorage endEditing];
}

@end
