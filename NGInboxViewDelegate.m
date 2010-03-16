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
	NSString *waveId;
}

@property (retain) NSString *waveId;

- (void) addParticipant:(NGParticipantId *)newParticipant;
- (NSString *) stringParticipants;
- (void) addAuthor:(NGParticipantId *)newAuthor;
- (NSString *)stringAuthors;

@end

@implementation NGWaveDigest

@synthesize waveId;

- (id) init {
	if (self = [super init]) {
		_participants = [[NSMutableArray alloc] init];
		_authors = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc {
	[_participants release];
	[_authors release];
	[super dealloc];
}

- (void) addParticipant:(NGParticipantId *)newParticipant {
	if (![_participants containsObject:newParticipant]) {
		[_participants addObject:newParticipant];
	}
}

- (NSString *) stringParticipants {
	NSMutableString *returnString = [[[NSMutableString alloc] init] autorelease];
	for (NGParticipantId *participantId in _participants) {
		[returnString appendFormat:@"%@, ", [participantId participantIdAtDomain]];
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
		[returnString appendFormat:@"%@, ", [participantId participantIdAtDomain]];
	}
	return returnString;
}

- (BOOL) isEqual:(id)object {
	return [[self waveId] isEqual:[object waveId]];
}

@end


@implementation NGInboxViewDelegate

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
		return [waveDigest waveId];
	}
	if ([identifier isEqual:@"authors"]) {
		return [waveDigest stringAuthors];
	}
	return @"TODO";
}

- (void) passSignal:(ProtocolWaveletUpdate *)update {
	NGWaveUrl *waveUrl = [[[NGWaveUrl alloc] initWithString:[update waveletName]] autorelease];
	assert([[[waveUrl waveId] waveId] isEqual:@"indexwave!indexwave"]);
	NSString *waveId = [[waveUrl waveletId] waveletId];
	/*
	ProtocolHashedVersion *resultingVersion = [update resultingVersion];
	int64_t version = [resultingVersion version];
	NSData *historyHash = [resultingVersion historyHash];
	 */
	NGWaveDigest *waveDigest;
	int oldIndex = -1;
	NSUInteger i, count = [inboxArray count];
	for (i = 0; i < count; i++) {
		NGWaveDigest *it = [inboxArray objectAtIndex:i];
		if ([[it waveId] isEqual:waveId]) {
			waveDigest = it;
			oldIndex = i;
			break;
		}
	}
	if (oldIndex == -1) {
		waveDigest = [[[NGWaveDigest alloc] init] autorelease];
		[waveDigest setWaveId:waveId];
	}
	for (ProtocolWaveletDelta *wd in [update appliedDeltaList]) {
		NSString *wdAuthor = [wd author];
		if (![wdAuthor isEqual:@"digest-author"]) {
			NSArray *wdAuthorLst = [wdAuthor componentsSeparatedByString:@"@"];
			[waveDigest addAuthor:[NGParticipantId participantIdWithDomain:[wdAuthorLst objectAtIndex:1] participantId:[wdAuthorLst objectAtIndex:0]]];
		}
		else {
			[waveDigest addAuthor:[NGParticipantId participantIdWithDomain:@"digest-author" participantId:@"digest-author"]];
		}

		for (ProtocolWaveletOperation *op in [wd operationList]) {
			//
		}
	}
	if (oldIndex == -1) {
		[inboxArray insertObject:waveDigest atIndex:0];
	}
	else {
		//[inboxArray replaceObjectAtIndex:oldIndex withObject:waveDigest];
		// above method is update in the old place, following is to replace in the top
		[inboxArray removeObjectAtIndex:oldIndex];
		[inboxArray insertObject:waveDigest atIndex:0];
	}
}

@end
