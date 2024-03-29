// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ObjectivecDescriptor.pb.h"

@implementation ObjectivecDescriptorRoot
static id<PBExtensionField> ObjectivecDescriptorRoot_objectivecFileOptions = nil;
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [ObjectivecDescriptorRoot class]) {
    ObjectivecDescriptorRoot_objectivecFileOptions =
      [[PBConcreteExtensionField extensionWithType:PBExtensionTypeMessage
                                     extendedClass:[FileOptions class]
                                       fieldNumber:1002
                                      defaultValue:[ObjectiveCFileOptions defaultInstance]
                               messageOrGroupClass:[ObjectiveCFileOptions class]
                                        isRepeated:NO
                                          isPacked:NO
                            isMessageSetWireFormat:NO] retain];
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    [DescriptorRoot registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
  [registry addExtension:ObjectivecDescriptorRoot_objectivecFileOptions];
}
+ (id<PBExtensionField>) objectivecFileOptions {
  return ObjectivecDescriptorRoot_objectivecFileOptions;
}
@end

@interface ObjectiveCFileOptions ()
@property (retain) NSString* package;
@property (retain) NSString* classPrefix;
@end

@implementation ObjectiveCFileOptions

- (BOOL) hasPackage {
  return !!hasPackage_;
}
- (void) setHasPackage:(BOOL) value {
  hasPackage_ = !!value;
}
@synthesize package;
- (BOOL) hasClassPrefix {
  return !!hasClassPrefix_;
}
- (void) setHasClassPrefix:(BOOL) value {
  hasClassPrefix_ = !!value;
}
@synthesize classPrefix;
- (void) dealloc {
  self.package = nil;
  self.classPrefix = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.package = @"";
    self.classPrefix = @"";
  }
  return self;
}
static ObjectiveCFileOptions* defaultObjectiveCFileOptionsInstance = nil;
+ (void) initialize {
  if (self == [ObjectiveCFileOptions class]) {
    defaultObjectiveCFileOptionsInstance = [[ObjectiveCFileOptions alloc] init];
  }
}
+ (ObjectiveCFileOptions*) defaultInstance {
  return defaultObjectiveCFileOptionsInstance;
}
- (ObjectiveCFileOptions*) defaultInstance {
  return defaultObjectiveCFileOptionsInstance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasPackage) {
    [output writeString:1 value:self.package];
  }
  if (self.hasClassPrefix) {
    [output writeString:2 value:self.classPrefix];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasPackage) {
    size += computeStringSize(1, self.package);
  }
  if (self.hasClassPrefix) {
    size += computeStringSize(2, self.classPrefix);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (ObjectiveCFileOptions*) parseFromData:(NSData*) data {
  return (ObjectiveCFileOptions*)[[[ObjectiveCFileOptions builder] mergeFromData:data] build];
}
+ (ObjectiveCFileOptions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ObjectiveCFileOptions*)[[[ObjectiveCFileOptions builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (ObjectiveCFileOptions*) parseFromInputStream:(NSInputStream*) input {
  return (ObjectiveCFileOptions*)[[[ObjectiveCFileOptions builder] mergeFromInputStream:input] build];
}
+ (ObjectiveCFileOptions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ObjectiveCFileOptions*)[[[ObjectiveCFileOptions builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (ObjectiveCFileOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (ObjectiveCFileOptions*)[[[ObjectiveCFileOptions builder] mergeFromCodedInputStream:input] build];
}
+ (ObjectiveCFileOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ObjectiveCFileOptions*)[[[ObjectiveCFileOptions builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (ObjectiveCFileOptions_Builder*) builder {
  return [[[ObjectiveCFileOptions_Builder alloc] init] autorelease];
}
+ (ObjectiveCFileOptions_Builder*) builderWithPrototype:(ObjectiveCFileOptions*) prototype {
  return [[ObjectiveCFileOptions builder] mergeFrom:prototype];
}
- (ObjectiveCFileOptions_Builder*) builder {
  return [ObjectiveCFileOptions builder];
}
@end

@interface ObjectiveCFileOptions_Builder()
@property (retain) ObjectiveCFileOptions* result;
@end

@implementation ObjectiveCFileOptions_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[ObjectiveCFileOptions alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (ObjectiveCFileOptions_Builder*) clear {
  self.result = [[[ObjectiveCFileOptions alloc] init] autorelease];
  return self;
}
- (ObjectiveCFileOptions_Builder*) clone {
  return [ObjectiveCFileOptions builderWithPrototype:result];
}
- (ObjectiveCFileOptions*) defaultInstance {
  return [ObjectiveCFileOptions defaultInstance];
}
- (ObjectiveCFileOptions*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (ObjectiveCFileOptions*) buildPartial {
  ObjectiveCFileOptions* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (ObjectiveCFileOptions_Builder*) mergeFrom:(ObjectiveCFileOptions*) other {
  if (other == [ObjectiveCFileOptions defaultInstance]) {
    return self;
  }
  if (other.hasPackage) {
    [self setPackage:other.package];
  }
  if (other.hasClassPrefix) {
    [self setClassPrefix:other.classPrefix];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (ObjectiveCFileOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (ObjectiveCFileOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setPackage:[input readString]];
        break;
      }
      case 18: {
        [self setClassPrefix:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasPackage {
  return result.hasPackage;
}
- (NSString*) package {
  return result.package;
}
- (ObjectiveCFileOptions_Builder*) setPackage:(NSString*) value {
  result.hasPackage = YES;
  result.package = value;
  return self;
}
- (ObjectiveCFileOptions_Builder*) clearPackage {
  result.hasPackage = NO;
  result.package = @"";
  return self;
}
- (BOOL) hasClassPrefix {
  return result.hasClassPrefix;
}
- (NSString*) classPrefix {
  return result.classPrefix;
}
- (ObjectiveCFileOptions_Builder*) setClassPrefix:(NSString*) value {
  result.hasClassPrefix = YES;
  result.classPrefix = value;
  return self;
}
- (ObjectiveCFileOptions_Builder*) clearClassPrefix {
  result.hasClassPrefix = NO;
  result.classPrefix = @"";
  return self;
}
@end

