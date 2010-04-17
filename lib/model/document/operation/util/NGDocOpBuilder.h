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

#import "../../../../proto/Common.pb.h"

#import "../component/NGCharacters.h"
#import "../component/NGDeleteCharacters.h"
#import "../component/NGElementStart.h"
#import "../component/NGElementEnd.h"
#import "../component/NGDeleteElementStart.h"
#import "../component/NGDeleteElementEnd.h"
#import "../component/NGRetain.h"

#import "NGBufferedDocOp.h"

@interface NGDocOpBuilder : NSObject {
	NSMutableArray *_docOpComponents;
}

+ (NGDocOpBuilder *) builder;

- (NGDocOpBuilder *) characters:(NSString *)characters;
- (NGDocOpBuilder *) deleteCharacters:(NSString *)characters;
- (NGDocOpBuilder *) elementStart:(NSString *)type;
- (NGDocOpBuilder *) elementEnd;
- (NGDocOpBuilder *) deleteElementStart:(NSString *)type;
- (NGDocOpBuilder *) deleteElementEnd;
- (NGDocOpBuilder *) retain:(NSInteger)retainItemCount;

- (ProtocolDocumentOperation *) build;

@end
