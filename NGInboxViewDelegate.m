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

#import "NGInboxViewDelegate.h"

@interface NGWaveDigest : NSObject {
	NSMutableArray *_participants;
	NSMutableArray *_authors;
	NGWaveId *waveId;
	NSMutableString *_digest;
}

@property (retain) NGWaveId *waveId;

- (void) addParticipant:(NGParticipantId *)newParticipant;
- (void) rmParticipant:(NGParticipantId *)oldParticipant;
- (NSString *) stringParticipants;
- (void) addAuthor:(NGParticipantId *)newAuthor;
- (NSString *)stringAuthors;
- (void) insertChars:(NSString *)chars atPosition:(int)pos;
- (void) deleteChars:(NSString *)chars atPosition:(int)pos;
- (NSString *)stringDigest;

@end

@implementation NGWaveDigest

@synthesize waveId;

- (id) init {
	if (self = [super init]) {
		_participants = [[NSMutableArray alloc] init];
		_authors = [[NSMutableArray alloc] init];
		_digest = [[NSMutableString alloc] init];
	}
	return self;
}

- (void) dealloc {
	[_participants release];
	[_authors release];
	[_digest release];
	[super dealloc];
}

- (void) addParticipant:(NGParticipantId *)newParticipant {
	if (![_participants containsObject:newParticipant]) {
		[_participants addObject:newParticipant];
	}
}

- (void) rmParticipant:(NGParticipantId *)oldParticipant {
	if ([_participants containsObject:oldParticipant]) {
		[_participants removeObject:oldParticipant];
	}
}

- (NSString *) stringParticipants {
	NSMutableString *returnString = [[[NSMutableString alloc] init] autorelease];
	for (NGParticipantId *participantId in _participants) {
		[returnString appendFormat:@"%@, ", [participantId serialise]];
	}
	return returnString;
}

- (void) addAuthor:(NGParticipantId *)newAuthor {
	if (![_authors containsObject:newAuthor]) {
		[_authors addObject:newAuthor];
	}
}

- (NSString *) stringAuthors {
	NSMutableString *returnString = [[[NSMutableString alloc] init] autorelease];
	for (NGParticipantId *participantId in _authors) {
		[returnString appendFormat:@"%@, ", [participantId serialise]];
	}
	return returnString;
}

- (void) insertChars:(NSString *)chars atPosition:(int)pos {
	assert(pos <= [_digest length]);
	[_digest insertString:chars atIndex:pos];
}

- (void) deleteChars:(NSString *)chars atPosition:(int)pos {
	assert((pos + [chars length]) <= [_digest length]);
	NSRange deleteRange = {pos, [chars length]};
	NSString *toBeDeletedChars = [_digest substringWithRange:deleteRange];
	assert([toBeDeletedChars isEqual:chars]);
	[_digest deleteCharactersInRange:deleteRange];
}

- (NSString *)stringDigest {
	return _digest;
}

- (BOOL) isEqual:(id)object {
	return [[self waveId] isEqual:[object waveId]];
}

@end


@implementation NGInboxViewDelegate

@synthesize currentUser;

- (id) init {
	if (self = [super init]) {
		inboxArray = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc {
	[inboxArray release];
	[super dealloc];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [inboxArray count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	NGWaveDigest *waveDigest = [inboxArray objectAtIndex:rowIndex];
	NSString *identifier = [aTableColumn identifier];
	if ([identifier isEqual:@"waveId"]) {
		return [[waveDigest waveId] waveId];
	}
	if ([identifier isEqual:@"authors"]) {
		return [waveDigest stringAuthors];
	}
	if ([identifier isEqual:@"participants"]) {
		return [waveDigest stringParticipants];
	}
	if ([identifier isEqual:@"digest"]) {
		return [waveDigest stringDigest];
	}
	return @"TODO";
}

- (NGWaveId *) getWaveIdByRowIndex:(NSInteger)rowIndex {
	NGWaveDigest *waveDigest = [inboxArray objectAtIndex:rowIndex];
	return [waveDigest waveId];
}

- (NSInteger) getIndexFromWaveName:(NGWaveletName *)waveName {
	NSAssert([[[waveName waveId] waveId] isEqual:@"indexwave!indexwave"], @"Message here must be the one for inbox!");
	NGWaveletId *waveId = [waveName waveletId];
	NSInteger oldIndex = -1;
	NSUInteger i, count = [inboxArray count];
	for (i = 0; i < count; i++) {
		NGWaveDigest *it = [inboxArray objectAtIndex:i];
		if ([[it waveId] isEqual:[NGWaveId waveIdWithDomain:[waveId domain] waveId:[waveId waveletId]]]) {
			oldIndex = i;
			break;
		}
	}
	return oldIndex;
}

- (NGWaveDigest *) getDigestFromIndex:(NSInteger)index andWaveName:(NGWaveletName *)waveName {
	NGWaveletId *waveId = [waveName waveletId];
	NGWaveDigest *waveDigest;
	if (index == -1) {
		waveDigest = [[[NGWaveDigest alloc] init] autorelease];
		[waveDigest setWaveId:[NGWaveId waveIdWithDomain:[waveId domain] waveId:[waveId waveletId]]];
	}
	else {
		waveDigest = [inboxArray objectAtIndex:index];
	}
	return waveDigest;
}

- (void) updateDigest:(NGWaveDigest *)digest withIndex:(NSInteger)index {
	if (index == -1) {
		[inboxArray insertObject:digest atIndex:0];
	}
	else {
		//[inboxArray replaceObjectAtIndex:oldIndex withObject:waveDigest];
		// above method is update in the old place, following is to replace in the top
		[inboxArray removeObjectAtIndex:index];
		[inboxArray insertObject:digest atIndex:0];
	}
}

- (void) addParticipant:(NGParticipantId *)participantId fromAuthor:(NGParticipantId *)author forWavelet:(NGWaveletName *)waveName {
	NSInteger oldIndex = [self getIndexFromWaveName:waveName];
	NGWaveDigest *waveDigest = [self getDigestFromIndex:oldIndex andWaveName:waveName];
	[waveDigest addAuthor:author];
	[waveDigest addParticipant:participantId];
	[self updateDigest:waveDigest withIndex:oldIndex];
}

- (void) removeParticipant:(NGParticipantId *)participantId fromAuthor:(NGParticipantId *)author forWavelet:(NGWaveletName *)waveName {
	NSInteger oldIndex = [self getIndexFromWaveName:waveName];
	NGWaveDigest *waveDigest = [self getDigestFromIndex:oldIndex andWaveName:waveName];
	[waveDigest addAuthor:author];
	if ([participantId isEqual:self.currentUser]) {
		NSAssert(oldIndex != -1, @"there should be a waveDigest which will contains this participant");
		[inboxArray removeObjectAtIndex:oldIndex];
		return;
	}
	else {
		[waveDigest rmParticipant:participantId];
	}
	[self updateDigest:waveDigest withIndex:oldIndex];
}

- (void) waveletDocument:(ProtocolWaveletOperation_MutateDocument *)document fromAuthor:(NGParticipantId *)author forWavelet:(NGWaveletName *)waveName {
	NSInteger oldIndex = [self getIndexFromWaveName:waveName];
	NGWaveDigest *waveDigest = [self getDigestFromIndex:oldIndex andWaveName:waveName];
	[waveDigest addAuthor:author];
	int pos = 0;
	for (ProtocolDocumentOperation_Component *comp in [[document documentOperation] componentList]) {
		if ([comp hasCharacters]) {
			NSString *chars = [comp characters];
			[waveDigest insertChars:chars atPosition:pos];
			pos += [chars length];
		}
		if ([comp hasDeleteCharacters]) {
			NSString *chars = [comp deleteCharacters];
			[waveDigest deleteChars:chars atPosition:pos];
		}
		if ([comp hasRetainItemCount]) {
			pos = [comp retainItemCount];
		}
	}
	[self updateDigest:waveDigest withIndex:oldIndex];
}

@end
