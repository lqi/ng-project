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

#import <Foundation/Foundation.h>

#import "../id/NGWaveletName.h"

@interface NGHashedVersion : NSObject {
	int64_t version;
	NSData *historyHash;
}

@property (assign) int64_t version;
@property (retain) NSData *historyHash;

+ (NGHashedVersion *) hashedVersion;
+ (NGHashedVersion *) hashedVersion:(NGWaveletName *)newWaveName;
+ (NGHashedVersion *) hashedVersion:(int64_t)theVersion withHistoryHash:(NSData *)theHistoryHash;

- (NSString *) stringValue;

@end
