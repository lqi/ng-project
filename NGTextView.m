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

- (void)openWithWaveId:(NGWaveId *)waveId waveletId:(NGWaveletId *)waveletId sequenceNo:(long)seqNo {
	_waveId = [waveId retain];
	_waveletId = [waveletId retain];
	_seqNo = seqNo;
	_waveRpcItems = [[NSMutableArray alloc] init];
}

- (void)close {
	[_waveRpcItems release];
	[_waveId release];
	[_waveletId release];
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
	NSLog(@"%d, %@", [self caretOffset], characters);
}

- (void)insertLineBreak:(id)sender {
	[self insertLineMutationDocument];
}

- (void)insertNewline:(id)sender {
	[self insertLineMutationDocument];
}

- (void)deleteBackward:(id)sender {
	if ([self caretOffset] == 0) {
		NSLog(@"Reach the very beginning!");
		return;
	}
	
	NSLog(@"%d, DELETEBACKWARD", [self caretOffset]);
}

- (void)deleteForward:(id)sender {
	if ([self caretOffset] == [self textLength]) {
		NSLog(@"Reach the very ending!");
		return;
	}
	
	NSLog(@"%d, DELETEFORWARD", [self caretOffset]);
}

- (NSInteger)caretOffset {
	return [[[self selectedRanges] objectAtIndex:0] rangeValue].location;
}

- (NSInteger)textLength {
	return [[self string] length];
}

- (void)insertLineMutationDocument {
	NSLog(@"%d, NEWLINE", [self caretOffset]);
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
