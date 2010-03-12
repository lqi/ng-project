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

@interface NgProjectAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	NSString *domain;
	long seqNo;
	NGNetwork *network;
	NGRandomIdGenerator *idGenerator;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction) goReceive:(id)sender;
- (IBAction) openIndex:(id)sender;
- (IBAction) newWave:(id)sender;
@end
