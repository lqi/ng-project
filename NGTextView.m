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
	_ngElementAttributes = [[NSMutableArray alloc] init];
	_ngElementAnnotations = [[NSMutableArray alloc] init];
}

- (void)close {
	[_ngElementAnnotations release];
	[_ngElementAttributes release];
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
	NGElementAttribute *elementAttribtues = [_ngElementAttributes objectAtIndex:lineStartPositionOffset];
	if ([elementAttribtues hasAttribute:@"i"]) {
		NSString *currentIndentString = [elementAttribtues attribute:@"i"];
		[self replaceAttributeInPosition:lineStartPositionOffset forKey:@"i" oldValue:currentIndentString newValue:[NSString stringWithFormat:@"%d", ([currentIndentString intValue] + 1)]];
	}
	else {
		[self updateAttributeInPosition:lineStartPositionOffset forKey:@"i" value:@"1"];
	}
}

- (void)insertBacktab:(id)sender {
	NSInteger lineStartPositionOffset = [self positionOffsetOfCurrentLineStart:[self caretOffset]];
	NGElementAttribute *elementAttribtues = [_ngElementAttributes objectAtIndex:lineStartPositionOffset];
	if ([elementAttribtues hasAttribute:@"i"]) {
		NSString *currentIndentString = [elementAttribtues attribute:@"i"];
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

- (void)alignLeft:(id)sender {
	NSInteger lineStartPositionOffset = [self positionOffsetOfCurrentLineStart:[self caretOffset]];
	NGElementAttribute *elementAttribtues = [_ngElementAttributes objectAtIndex:lineStartPositionOffset];
	if ([elementAttribtues hasAttribute:@"a"]) {
		NSString *currentAlignment = [elementAttribtues attribute:@"a"];
		[self replaceAttributeInPosition:lineStartPositionOffset forKey:@"a" oldValue:currentAlignment newValue:@"l"];
	}
	else {
		[self updateAttributeInPosition:lineStartPositionOffset forKey:@"a" value:@"l"];
	}
}

- (void)alignCenter:(id)sender {
	NSInteger lineStartPositionOffset = [self positionOffsetOfCurrentLineStart:[self caretOffset]];
	NGElementAttribute *elementAttribtues = [_ngElementAttributes objectAtIndex:lineStartPositionOffset];
	if ([elementAttribtues hasAttribute:@"a"]) {
		NSString *currentAlignment = [elementAttribtues attribute:@"a"];
		[self replaceAttributeInPosition:lineStartPositionOffset forKey:@"a" oldValue:currentAlignment newValue:@"c"];
	}
	else {
		[self updateAttributeInPosition:lineStartPositionOffset forKey:@"a" value:@"c"];
	}
}

- (void)alignRight:(id)sender {
	NSInteger lineStartPositionOffset = [self positionOffsetOfCurrentLineStart:[self caretOffset]];
	NGElementAttribute *elementAttribtues = [_ngElementAttributes objectAtIndex:lineStartPositionOffset];
	if ([elementAttribtues hasAttribute:@"a"]) {
		NSString *currentAlignment = [elementAttribtues attribute:@"a"];
		[self replaceAttributeInPosition:lineStartPositionOffset forKey:@"a" oldValue:currentAlignment newValue:@"r"];
	}
	else {
		[self updateAttributeInPosition:lineStartPositionOffset forKey:@"a" value:@"r"];
	}
}

- (NSInteger)caretOffset {
	return [[[self selectedRanges] objectAtIndex:0] rangeValue].location;
}

- (NSInteger)caretOffsetOfPositionOffset:(int)positionOffset {
	int caret = 0;
	for (int i = 0; i < positionOffset; i++) {
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
				caret++;
			}
		}
		if ([thisItem isEqual:@"character"]) {
			caret++;
		}
	}
	return caret;
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
	NSInteger positionOffset = [self positionOffset:caretOffset] - 1; // a little tricky here, as <line></line>characters, so before the first character of each line, there is a </line> tag
	return [self positionOffsetOfPreviousLineStart:positionOffset];
}

- (NSInteger)positionOffsetOfPreviousLineStart:(int)positionOffset {
	int currentPositionOffset = positionOffset;
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
	NGDocOpBuilder *blipDocOpBuilder = [[[[NGDocOpBuilder builder] retain:retainItemCount] characters:characters] retain:([self positionLength] - retainItemCount)];
	[self sendDocumentOperation:[blipDocOpBuilder build]];
}

- (void)insertLineMutationDocument:(int)caretOffset {
	int retainItemCount = [self positionOffset:caretOffset];
	NGDocOpBuilder *blipDocOpBuilder = [[[[[NGDocOpBuilder builder] retain:retainItemCount] elementStart:@"line" withAttributes:[NGDocAttributes emptyAttribute]] elementEnd] retain:([self positionLength] - retainItemCount)];
	[self sendDocumentOperation:[blipDocOpBuilder build]];
}

- (void)deleteCurrentElement:(int)caretOffset {
	int positionOffset = [self positionOffset:caretOffset];
	NSString *thisItem = [_waveRpcItems objectAtIndex:positionOffset];
	if ([thisItem isEqual:@"character"]) {
		NSString *charactersToBeDeleted = [[self string] substringWithRange:NSMakeRange(caretOffset, 1)];
		NGDocOpBuilder *docOpBuilder = [[[[NGDocOpBuilder builder] retain:positionOffset] deleteCharacters:charactersToBeDeleted] retain:([self positionLength] - positionOffset - [charactersToBeDeleted length])];
		[self sendDocumentOperation:[docOpBuilder build]];
	}
	else if ([thisItem isEqual:@"lineStart"]) {
		NGDocOpBuilder *docOpBuilder = [[[[[NGDocOpBuilder builder] retain:positionOffset] deleteElementStart:@"line"] deleteElementEnd] retain:([self positionLength] - positionOffset - 2)];
		[self sendDocumentOperation:[docOpBuilder build]];
	}
}

- (void)updateAttributeInPosition:(int)positionOffset forKey:(NSString *)key value:(NSString *)value {
	[self sendDocumentOperation:[[[[[NGDocOpBuilder builder] retain:positionOffset] updateAttributes:[[NGDocAttributesUpdate emptyAttributesUpdate] addAttributeWithKey:key andOnlyNewValue:value]] retain:([self positionLength] - positionOffset - 1)] build]];
}

- (void)replaceAttributeInPosition:(int)positionOffset forKey:(NSString *)key oldValue:(NSString *)oldValue newValue:(NSString *)newValue {
	[self sendDocumentOperation:[[[[[NGDocOpBuilder builder] retain:positionOffset] updateAttributes:[[NGDocAttributesUpdate emptyAttributesUpdate] addAttributeWithKey:key oldValue:oldValue andNewValue:newValue]] retain:([self positionLength] - positionOffset - 1)] build]];
}

- (void)sendDocumentOperation:(NGMutateDocument *)docOp {
	NGWaveName *waveUrl = [[NGWaveName alloc] initWithWaveId:_waveId WaveletId:_waveletId];
	NSString *waveName = [waveUrl url];
	[waveUrl release];
	
	ProtocolSubmitRequest_Builder *submitRequestBuilder = [ProtocolSubmitRequest builder];
	[submitRequestBuilder setWaveletName:waveName];
	
	NGWaveletDelta *waveletDelta = [[[NGWaveletDeltaBuilder builder:_participantId] docOp:_blipId andMutateDocument:docOp] build];
	NGHashedVersion *hashedVersion = [NGHashedVersion hashedVersion:self.waveletVersion withHistoryHash:self.waveletHistoryHash];
	
	[submitRequestBuilder setDelta:[NGWaveletDeltaSerializer bufferedWaveletDelta:waveletDelta withVersion:hashedVersion]];
	
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
	NGElementAnnotationUpdate *annotationUpdates = [[NGElementAnnotationUpdate alloc] init];
	
	NSDictionary *styleDictionary = [NSDictionary dictionary];
	NGElementAnnotation *elementAnnotations = [NGElementAnnotation annotations];
	
	int cursor = 0;
	int rpcPosition = 0;
	[textStorage beginEditing];
	for (ProtocolDocumentOperation_Component *comp in [[mutateDocument documentOperation] componentList]) {
		if ([comp hasCharacters]) {
			int currentLineStartPositionOffset = [self positionOffsetOfPreviousLineStart:rpcPosition - 1];
			
			NSString *chars = [comp characters];
			[textStorage replaceCharactersInRange:NSMakeRange(cursor, 0) withString:chars];
			cursor += [chars length];
			for (int i = 0; i < [chars length]; i++) {
				[_ngElementAttributes insertObject:[NGElementAttribute attributes] atIndex:rpcPosition];
				[_ngElementAnnotations insertObject:[elementAnnotations copy] atIndex:rpcPosition];
				int currentCaret = [self caretOffsetOfPositionOffset:rpcPosition];
				styleDictionary = [NGTextViewEditingStyle styleFromElementAttributes:[_ngElementAttributes objectAtIndex:currentLineStartPositionOffset] andElementAnnotations:[elementAnnotations copy]];
				[textStorage setAttributes:[styleDictionary copy] range:NSMakeRange(currentCaret, 1)];
				[_waveRpcItems insertObject:@"character" atIndex:rpcPosition++];
			}
		}
		if ([comp hasDeleteCharacters]) {
			NSString *chars = [comp deleteCharacters];
			// TODO: There should be validation before deleting the characters
			[textStorage deleteCharactersInRange:NSMakeRange(cursor, [chars length])];
			for (int i = 0; i < [chars length]; i++) {
				[_ngElementAttributes removeObjectAtIndex:rpcPosition];
				[_ngElementAnnotations removeObjectAtIndex:rpcPosition];
				[_waveRpcItems removeObjectAtIndex:rpcPosition];
			}
		}
		if ([comp hasRetainItemCount]) {
			for (int i = rpcPosition; i < rpcPosition + [comp retainItemCount]; i++) {
				NGElementAnnotation *currentElementAnnotation = [_ngElementAnnotations objectAtIndex:i];
				[currentElementAnnotation merge:annotationUpdates];
				[_ngElementAnnotations replaceObjectAtIndex:i withObject:currentElementAnnotation];
				elementAnnotations = [currentElementAnnotation copy];
				if (i >= [self positionOffset:0]) {
					int thisLineStartPositionOffset = [self positionOffsetOfPreviousLineStart:i];
					styleDictionary = [NGTextViewEditingStyle styleFromElementAttributes:[_ngElementAttributes objectAtIndex:thisLineStartPositionOffset] andElementAnnotations:currentElementAnnotation];
					int currentCaret = [self caretOffsetOfPositionOffset:i];
					if (currentCaret < [self textLength]) {
						[textStorage setAttributes:[styleDictionary copy] range:NSMakeRange(currentCaret, 1)];
					}
				}
			}
			
			rpcPosition += [comp retainItemCount];
			if (rpcPosition == [self positionLength]) {
				break;
			}
			
			int currentLineStartPositionOffset = [self positionOffsetOfPreviousLineStart:rpcPosition];
			NSAssert([[_waveRpcItems objectAtIndex:currentLineStartPositionOffset] isEqual:@"lineStart"], @"this position should be a line start");
			NGElementAttribute *thisElementAttribute = [_ngElementAttributes objectAtIndex:currentLineStartPositionOffset];
			//elementAnnotations = [[_ngElementAnnotations objectAtIndex:rpcPosition] copy];
			//[elementAnnotations merge:annotationUpdates];
			styleDictionary = [NGTextViewEditingStyle styleFromElementAttributes:thisElementAttribute andElementAnnotations:elementAnnotations];
			
			cursor = [self caretOffsetOfPositionOffset:rpcPosition];
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
				[_ngElementAttributes insertObject:[NGElementAttribute attributes] atIndex:rpcPosition];
				[_ngElementAnnotations insertObject:[NGElementAnnotation annotations] atIndex:rpcPosition];
				[_waveRpcItems insertObject:@"contributorStart" atIndex:rpcPosition++];
			}
			else if ([elementType isEqual:@"body"]) {
				[_ngElementAttributes insertObject:[NGElementAttribute attributes] atIndex:rpcPosition];
				[_ngElementAnnotations insertObject:[elementAnnotations copy] atIndex:rpcPosition];
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
				
				NGElementAttribute *elementStartAttributes = [[NGElementAttribute alloc] init];
				[elementStartAttributes parseFromKeyValuePairs:[elementStart attributeList]];
				[_ngElementAttributes insertObject:elementStartAttributes atIndex:rpcPosition];
				[elementStartAttributes release];
				[_ngElementAnnotations insertObject:[elementAnnotations copy] atIndex:rpcPosition];
				styleDictionary = [NGTextViewEditingStyle styleFromElementAttributes:[_ngElementAttributes objectAtIndex:rpcPosition] andElementAnnotations:[_ngElementAnnotations objectAtIndex:rpcPosition]];
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
					[_ngElementAttributes insertObject:[NGElementAttribute attributes] atIndex:rpcPosition];
					[_ngElementAnnotations insertObject:[elementAnnotations copy] atIndex:rpcPosition];
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
				[_ngElementAttributes removeObjectAtIndex:rpcPosition];
				[_ngElementAnnotations removeObjectAtIndex:rpcPosition];
				[_waveRpcItems removeObjectAtIndex:rpcPosition];
			}
			else {
				// TODO: at the moment, only lineBreak could be deleted
			}
		}
		if ([comp hasDeleteElementEnd]) {
			if ([comp deleteElementEnd]) {
				NSAssert([[_waveRpcItems objectAtIndex:rpcPosition] isEqual:@"elementEnd"], @"Technically, this element should be elementEnd for a lineStart");
				[_ngElementAttributes removeObjectAtIndex:rpcPosition];
				[_ngElementAnnotations removeObjectAtIndex:rpcPosition];
				[_waveRpcItems removeObjectAtIndex:rpcPosition];
			}
		}
		if ([comp hasUpdateAttributes]) {
			NGElementAttribute *elementAttributes = [_ngElementAttributes objectAtIndex:rpcPosition];
			[elementAttributes parseFromKeyValueUpdates:[[comp updateAttributes] attributeUpdateList]];
			
			NSRange paragraphRange;
			if ([[textStorage string] length] == 0) {
				paragraphRange = NSMakeRange(0, 0);
			}
			else {
				paragraphRange = [[textStorage string] paragraphRangeForRange: NSMakeRange(cursor + 1, 0)];
			}
			for (int i = paragraphRange.location; i < paragraphRange.location + paragraphRange.length; i++) {
				styleDictionary = [NGTextViewEditingStyle styleFromElementAttributes:elementAttributes andElementAnnotations:[_ngElementAnnotations objectAtIndex:[self positionOffset:i]]];
				[textStorage setAttributes:[styleDictionary copy] range:NSMakeRange(i, 1)];
			}
			
			[_ngElementAttributes replaceObjectAtIndex:rpcPosition withObject:elementAttributes];
			rpcPosition++;
		}
		if ([comp hasReplaceAttributes]) {
			NSLog(@"TODO: Replace Attribute: %@", [_waveRpcItems objectAtIndex:rpcPosition++]); // TODO: replace attribute
		}
		if ([comp hasAnnotationBoundary]) {
			ProtocolDocumentOperation_Component_AnnotationBoundary *annotationBoundary = [comp annotationBoundary];
			[annotationUpdates parse:annotationBoundary];
			[elementAnnotations merge:annotationUpdates];
		}
	}
	[textStorage endEditing];
	[styleDictionary release];
	[annotationUpdates release];
	NSAssert(rpcPosition == [self positionLength], @"for each set of document operations, entire document should be went through.");
}

@end
