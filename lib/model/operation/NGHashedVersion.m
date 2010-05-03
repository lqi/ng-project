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

#import "NGHashedVersion.h"

@implementation NGHashedVersion

@synthesize version;
@synthesize historyHash;

- (id) init {
	if (self = [super init]) {
		self.version = 0;
		self.historyHash = [NSData data];
	}
	return self;
}

+ (NGHashedVersion *) hashedVersion {
	return [[[NGHashedVersion alloc] init] autorelease];
}

+ (NGHashedVersion *) hashedVersion:(NGWaveName *)newWaveName {
	NGHashedVersion *hashedVersionInstance = [[[NGHashedVersion alloc] init] autorelease];
	hashedVersionInstance.historyHash = [[newWaveName url] dataUsingEncoding:NSUTF8StringEncoding];
	return hashedVersionInstance;
}

+ (NGHashedVersion *) hashedVersion:(int64_t)theVersion withHistoryHash:(NSData *)theHistoryHash {
	NGHashedVersion *hashedVersionInstance = [[[NGHashedVersion alloc] init] autorelease];
	hashedVersionInstance.version = theVersion;
	hashedVersionInstance.historyHash = theHistoryHash;
	return hashedVersionInstance;
}

- (NSString *) stringValue {
	NSMutableString *returnStringValue = [NSMutableString stringWithFormat:@"%d, ", self.version];
	[returnStringValue appendString:[self.historyHash description]];
	return returnStringValue;
}

@end
