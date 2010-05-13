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

#import <Cocoa/Cocoa.h>

#import "NGHeader.h"

#import "NGInboxViewDelegate.h"
#import "NGTextView.h"

@interface NgProjectAppDelegate : NSObject <NGClientRpcDelegate> /*<NSApplicationDelegate>*/ {
    NSWindow *window;
	NSTextField *statusLabel;
	NSTextField *currentUser;
	NSTableView *inboxTableView;
	NSTextField *currentWave;
	NSTextField *versionInfo;
	NSTextField *participantAdd;
	NSComboBox *participantList;
	NGTextView *waveTextView;
	NSTextField *tagAdd;
	NSComboBox *tagList;
	
	NGInboxViewDelegate *inboxViewDelegate;
	
	BOOL _hasWaveOpened;
	
	NSString *_domain;
	NGParticipantId *_participantId;
	NGIdGenerator *_idGenerator;
	
	NGHost *_host;
	NGClientRpc *_rpc;
	NGClientRpcChannel *_channel;
	NSMutableArray *_controllerMap;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *statusLabel;
@property (assign) IBOutlet NSTextField *currentUser;
@property (assign) IBOutlet NSTableView *inboxTableView;
@property (assign) IBOutlet NSTextField *currentWave;
@property (assign) IBOutlet NSTextField *versionInfo;
@property (assign) IBOutlet NSTextField *participantAdd;
@property (assign) IBOutlet NSComboBox *participantList;
@property (assign) IBOutlet NGTextView *waveTextView;
@property (assign) IBOutlet NSTextField *tagAdd;
@property (assign) IBOutlet NSComboBox *tagList;

//- (void) connectionStatueController;
- (void) openInbox;
- (IBAction) newWave:(id)sender;

- (IBAction) openWave:(id)sender;
- (IBAction) closeWave:(id)sender;

- (IBAction) addParticipant:(id)sender;
- (IBAction) rmParticipant:(id)sender;
- (IBAction) rmSelf:(id)sender;
- (IBAction) addTag:(id)sender;
- (IBAction) rmTag:(id)sender;

- (IBAction) shutdown:(id)sender;

- (void)sendWaveletDelta:(NGWaveletDelta *)delta;
- (NGHashedVersion *) getHashedVersion;

@end
