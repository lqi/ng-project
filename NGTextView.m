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
	_elementAttributes = [[NSMutableArray alloc] init];
}

- (void)close {
	[_elementAttributes release];
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
	NSInteger lineStartPositionOffset = [self positionOffsetOfCurrentLineStart:[self caretOffset]];
	NSDictionary *elementAttribtues = [_elementAttributes objectAtIndex:lineStartPositionOffset];
	if ([elementAttribtues objectForKey:@"i"] == nil) {
		[self updateAttributeInPosition:lineStartPositionOffset forKey:@"i" value:@"1"];
	}
	else {
		NSString *currentIndentString = [elementAttribtues valueForKey:@"i"];
		[self replaceAttributeInPosition:lineStartPositionOffset forKey:@"i" oldValue:currentIndentString newValue:[NSString stringWithFormat:@"%d", ([currentIndentString intValue] + 1)]];
	}
}

- (void)insertBacktab:(id)sender {
	NSInteger lineStartPositionOffset = [self positionOffsetOfCurrentLineStart:[self caretOffset]];
	NSDictionary *elementAttribtues = [_elementAttributes objectAtIndex:lineStartPositionOffset];
	if ([elementAttribtues objectForKey:@"i"] != nil) {
		NSString *currentIndentString = [elementAttribtues valueForKey:@"i"];
		if ([currentIndentString intValue] > 0) {
			[self replaceAttributeInPosition:lineStartPositionOffset forKey:@"i" oldValue:currentIndentString newValue:[NSString stringWithFormat:@"%d", ([currentIndentString intValue] - 1)]];
		}
	}
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
		int firstCharacterPosition = 0;
		while (YES) {
			NSString *thisItem = [_waveRpcItems objectAtIndex:firstCharacterPosition];
			firstCharacterPosition++;
			if ([thisItem isEqual:@"lineStart"]) {
				if ([[_waveRpcItems objectAtIndex:firstCharacterPosition] isEqual:@"elementEnd"]) {
					break;
				}
			}
		}
		return firstCharacterPosition + 1;
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

- (NSInteger)positionOffsetOfCurrentLineStart:(int)caretOffset {
	NSInteger currentPositionOffset = [self positionOffset:caretOffset];
	while (currentPositionOffset >= 0) {
		if ([[_waveRpcItems objectAtIndex:currentPositionOffset] isEqual:@"lineStart"]) {
			break;
		}
		currentPositionOffset--;
	}
	NSAssert(currentPositionOffset != 0, @"I am quite sure it should not be zero!");
	return currentPositionOffset;
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

- (void)updateAttributeInPosition:(int)positionOffset forKey:(NSString *)key value:(NSString *)value {
	ProtocolDocumentOperation_Component_KeyValueUpdate_Builder *keyValueUpdateBuilder = [ProtocolDocumentOperation_Component_KeyValueUpdate builder];
	[keyValueUpdateBuilder setKey:key];
	[keyValueUpdateBuilder setNewValue:value];
	
	ProtocolDocumentOperation_Component_UpdateAttributes_Builder *updateAttributesBuilder = [ProtocolDocumentOperation_Component_UpdateAttributes builder];
	[updateAttributesBuilder addAttributeUpdate:[keyValueUpdateBuilder build]];
	
	ProtocolDocumentOperation_Builder *blipDocOpBuilder = [ProtocolDocumentOperation builder];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setRetainItemCount:positionOffset] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setUpdateAttributes:[updateAttributesBuilder build]] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setRetainItemCount:([self positionLength] - positionOffset - 1)] build]]; 
	
	[self sendDocumentOperation:[blipDocOpBuilder build]];
}

- (void)replaceAttributeInPosition:(int)positionOffset forKey:(NSString *)key oldValue:(NSString *)oldValue newValue:(NSString *)newValue {
	ProtocolDocumentOperation_Component_KeyValueUpdate_Builder *keyValueUpdateBuilder = [ProtocolDocumentOperation_Component_KeyValueUpdate builder];
	[keyValueUpdateBuilder setKey:key];
	[keyValueUpdateBuilder setOldValue:oldValue];
	[keyValueUpdateBuilder setNewValue:newValue];
	
	ProtocolDocumentOperation_Component_UpdateAttributes_Builder *updateAttributesBuilder = [ProtocolDocumentOperation_Component_UpdateAttributes builder];
	[updateAttributesBuilder addAttributeUpdate:[keyValueUpdateBuilder build]];
	
	ProtocolDocumentOperation_Builder *blipDocOpBuilder = [ProtocolDocumentOperation builder];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setRetainItemCount:positionOffset] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setUpdateAttributes:[updateAttributesBuilder build]] build]];
	[blipDocOpBuilder addComponent:[[[ProtocolDocumentOperation_Component builder] setRetainItemCount:([self positionLength] - positionOffset - 1)] build]]; 
	
	[self sendDocumentOperation:[blipDocOpBuilder build]];
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
	NSString *documentId = [mutateDocument documentId];
	if ([documentId isEqual:@"conversation"]) {
		for (ProtocolDocumentOperation_Component *comp in [[mutateDocument documentOperation] componentList]) {
			if ([comp hasElementStart]) {
				ProtocolDocumentOperation_Component_ElementStart *elementStart = [comp elementStart];
				NSString *elementType = [elementStart type];
				if ([elementType isEqual:@"conversation"]) {
					// TODO: ignore at the moment as there is only one blip
				}
				else if ([elementType isEqual:@"blip"]) {
					ProtocolDocumentOperation_Component_KeyValuePair *blipIdAttribute = [elementStart attributeAtIndex:0];
					NSAssert([[blipIdAttribute key] isEqual:@"id"], @"blip id attribute should has the key of id");
					_blipId = [blipIdAttribute value];
				}
			}
			if ([comp hasElementEnd]) {
				if ([comp elementEnd]) {
					// :)
				}
			}
		}
		return;
	}
	else {
		// TODO: only handle blip document
		NSString *firstTwoCharacterOfDocumentId = [documentId substringWithRange:NSMakeRange(0, 2)];
		if (![firstTwoCharacterOfDocumentId isEqual:@"b+"]) {
			return;
		}
	}

	
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
				[_elementAttributes insertObject:[NSDictionary dictionary] atIndex:rpcPosition];
				[_waveRpcItems insertObject:@"character" atIndex:rpcPosition++];
			}
		}
		if ([comp hasDeleteCharacters]) {
			NSString *chars = [comp deleteCharacters];
			// TODO: There should be validation before deleting the characters
			[textStorage deleteCharactersInRange:NSMakeRange(cursor, [chars length])];
			for (int i = 0; i < [chars length]; i++) {
				[_elementAttributes removeObjectAtIndex:rpcPosition];
				[_waveRpcItems removeObjectAtIndex:rpcPosition];
			}
		}
		if ([comp hasRetainItemCount]) {
			rpcPosition += [comp retainItemCount];
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
				NSLog(@"should nenver reach here at the moment"); // TODO: ignore at the moment as there is only one blip
			}
			else if ([elementType isEqual:@"blip"]) {
				NSLog(@"should nenver reach here at the moment"); // TODO: ignore at the moment as there is only one blip
			}
			else if ([elementType isEqual:@"contributor"]) {
				[_elementAttributes insertObject:[NSDictionary dictionary] atIndex:rpcPosition];
				[_waveRpcItems insertObject:@"contributorStart" atIndex:rpcPosition++];
			}
			else if ([elementType isEqual:@"body"]) {
				[_elementAttributes insertObject:[NSDictionary dictionary] atIndex:rpcPosition];
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
				[_elementAttributes insertObject:[NSDictionary dictionary] atIndex:rpcPosition];
				[_waveRpcItems insertObject:@"lineStart" atIndex:rpcPosition++];
			}
		}
		if ([comp hasElementEnd]) {
			if ([comp elementEnd]) {
				NSString *elementType = [[elementStack lastObject] retain];
				[elementStack removeLastObject];
				if ([elementType isEqual:@"blip"] || [elementType isEqual:@"conversation"]) {
					NSLog(@"never reach here at the moment!"); // TODO: ignore at the moment as there is only one blip
				}
				else {
					[_elementAttributes insertObject:[NSDictionary dictionary] atIndex:rpcPosition];
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
				[_elementAttributes removeObjectAtIndex:rpcPosition];
				[_waveRpcItems removeObjectAtIndex:rpcPosition];
			}
			else {
				// TODO: at the moment, only lineBreak could be deleted
			}
		}
		if ([comp hasDeleteElementEnd]) {
			if ([comp deleteElementEnd]) {
				NSAssert([[_waveRpcItems objectAtIndex:rpcPosition] isEqual:@"elementEnd"], @"Technically, this element should be elementEnd for a lineStart");
				[_elementAttributes removeObjectAtIndex:rpcPosition];
				[_waveRpcItems removeObjectAtIndex:rpcPosition];
			}
		}
		if ([comp hasUpdateAttributes]) {
			NSMutableDictionary *elementAttributes = [NSMutableDictionary dictionaryWithDictionary:[_elementAttributes objectAtIndex:rpcPosition]];
			NSString *elementType = [_waveRpcItems objectAtIndex:rpcPosition];
			for (ProtocolDocumentOperation_Component_KeyValueUpdate *attributeUpdate in [[comp updateAttributes] attributeUpdateList]) {
				if ([elementType isEqual:@"lineStart"]) {
					NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
					[paragraphStyle setParagraphStyle:[textStorage attribute:NSParagraphStyleAttributeName atIndex:cursor effectiveRange:NULL]];
					if ([[attributeUpdate key] isEqual:@"i"]) {
						int value;
						/* TODO: assert old value
						if ([attributeUpdate hasOldValue]) {
							NSString *oldValueString = [attributeUpdate oldValue];
							NSAssert([oldValueString isEqual:[elementAttributes valueForKey:@"i"]], @"old value should equals to the one in the element attribute array");
						}
						 */
						if ([attributeUpdate hasNewValue]) {
							NSString *newValueString = [attributeUpdate newValue];
							[elementAttributes setValue:newValueString forKey:@"i"];
							value = [newValueString intValue];
						}
						[paragraphStyle setHeadIndent:(CGFloat) (24 * value)];
						[paragraphStyle setFirstLineHeadIndent:(CGFloat) (24 * value)];
					}
					if ([[attributeUpdate key] isEqual:@"a"]) {
						NSString *alignment = @"l";
						if ([attributeUpdate hasOldValue]) {
							alignment = [attributeUpdate oldValue];
						}
						if ([attributeUpdate hasNewValue]) {
							alignment = [attributeUpdate newValue];
						}
						if ([alignment isEqual:@"l"]) {
							[paragraphStyle setAlignment:NSNaturalTextAlignment];
						}
						else if ([alignment isEqual:@"c"]) {
							[paragraphStyle setAlignment:NSCenterTextAlignment];
						}
						else if([alignment isEqual:@"r"]) {
							[paragraphStyle setAlignment:NSRightTextAlignment];
						}
					}
					NSRange paragraphRange = [[textStorage string] paragraphRangeForRange: NSMakeRange(cursor + 1, 0)]; // TODO: why cursor + 1?
					[textStorage addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:paragraphRange];
					[paragraphStyle release];
				}
			}
			[_elementAttributes replaceObjectAtIndex:rpcPosition withObject:elementAttributes];
			rpcPosition++;
		}
		if ([comp hasReplaceAttributes]) {
			NSLog(@"TODO: Replace Attribute: %@", [_waveRpcItems objectAtIndex:rpcPosition++]); // TODO: replace attribute
		}
		if ([comp hasAnnotationBoundary]) {
			// TODO: annotationBoundary
		}
	}
	[textStorage endEditing];
	NSAssert(rpcPosition == [self positionLength], @"for each set of document operations, entire document should be went through.");
}

@end
