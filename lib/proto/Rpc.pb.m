// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "Rpc.pb.h"

@implementation RpcRoot
static id<PBExtensionField> RpcRoot_isStreamingRpc = nil;
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [RpcRoot class]) {
    RpcRoot_isStreamingRpc =
      [[PBConcreteExtensionField extensionWithType:PBExtensionTypeBool
                                     extendedClass:[MethodOptions class]
                                       fieldNumber:1003
                                      defaultValue:[NSNumber numberWithBool:NO]
                               messageOrGroupClass:[NSNumber class]
                                        isRepeated:NO
                                          isPacked:NO
                            isMessageSetWireFormat:NO] retain];
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    [DescriptorRoot registerAllExtensions:registry];
    [ObjectivecDescriptorRoot registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
  [registry addExtension:RpcRoot_isStreamingRpc];
}
+ (id<PBExtensionField>) isStreamingRpc {
  return RpcRoot_isStreamingRpc;
}
@end

@interface CancelRpc ()
@end

@implementation CancelRpc

- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
  }
  return self;
}
static CancelRpc* defaultCancelRpcInstance = nil;
+ (void) initialize {
  if (self == [CancelRpc class]) {
    defaultCancelRpcInstance = [[CancelRpc alloc] init];
  }
}
+ (CancelRpc*) defaultInstance {
  return defaultCancelRpcInstance;
}
- (CancelRpc*) defaultInstance {
  return defaultCancelRpcInstance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (CancelRpc*) parseFromData:(NSData*) data {
  return (CancelRpc*)[[[CancelRpc builder] mergeFromData:data] build];
}
+ (CancelRpc*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (CancelRpc*)[[[CancelRpc builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (CancelRpc*) parseFromInputStream:(NSInputStream*) input {
  return (CancelRpc*)[[[CancelRpc builder] mergeFromInputStream:input] build];
}
+ (CancelRpc*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (CancelRpc*)[[[CancelRpc builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (CancelRpc*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (CancelRpc*)[[[CancelRpc builder] mergeFromCodedInputStream:input] build];
}
+ (CancelRpc*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (CancelRpc*)[[[CancelRpc builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (CancelRpc_Builder*) builder {
  return [[[CancelRpc_Builder alloc] init] autorelease];
}
+ (CancelRpc_Builder*) builderWithPrototype:(CancelRpc*) prototype {
  return [[CancelRpc builder] mergeFrom:prototype];
}
- (CancelRpc_Builder*) builder {
  return [CancelRpc builder];
}
@end

@interface CancelRpc_Builder()
@property (retain) CancelRpc* result;
@end

@implementation CancelRpc_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[CancelRpc alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (CancelRpc_Builder*) clear {
  self.result = [[[CancelRpc alloc] init] autorelease];
  return self;
}
- (CancelRpc_Builder*) clone {
  return [CancelRpc builderWithPrototype:result];
}
- (CancelRpc*) defaultInstance {
  return [CancelRpc defaultInstance];
}
- (CancelRpc*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (CancelRpc*) buildPartial {
  CancelRpc* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (CancelRpc_Builder*) mergeFrom:(CancelRpc*) other {
  if (other == [CancelRpc defaultInstance]) {
    return self;
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (CancelRpc_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (CancelRpc_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
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
    }
  }
}
@end

@interface RpcFinished ()
@property BOOL failed;
@property (retain) NSString* errorText;
@end

@implementation RpcFinished

- (BOOL) hasFailed {
  return !!hasFailed_;
}
- (void) setHasFailed:(BOOL) value {
  hasFailed_ = !!value;
}
- (BOOL) failed {
  return !!failed_;
}
- (void) setFailed:(BOOL) value {
  failed_ = !!value;
}
- (BOOL) hasErrorText {
  return !!hasErrorText_;
}
- (void) setHasErrorText:(BOOL) value {
  hasErrorText_ = !!value;
}
@synthesize errorText;
- (void) dealloc {
  self.errorText = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.failed = NO;
    self.errorText = @"";
  }
  return self;
}
static RpcFinished* defaultRpcFinishedInstance = nil;
+ (void) initialize {
  if (self == [RpcFinished class]) {
    defaultRpcFinishedInstance = [[RpcFinished alloc] init];
  }
}
+ (RpcFinished*) defaultInstance {
  return defaultRpcFinishedInstance;
}
- (RpcFinished*) defaultInstance {
  return defaultRpcFinishedInstance;
}
- (BOOL) isInitialized {
  if (!self.hasFailed) {
    return NO;
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasFailed) {
    [output writeBool:1 value:self.failed];
  }
  if (self.hasErrorText) {
    [output writeString:2 value:self.errorText];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasFailed) {
    size += computeBoolSize(1, self.failed);
  }
  if (self.hasErrorText) {
    size += computeStringSize(2, self.errorText);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (RpcFinished*) parseFromData:(NSData*) data {
  return (RpcFinished*)[[[RpcFinished builder] mergeFromData:data] build];
}
+ (RpcFinished*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (RpcFinished*)[[[RpcFinished builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (RpcFinished*) parseFromInputStream:(NSInputStream*) input {
  return (RpcFinished*)[[[RpcFinished builder] mergeFromInputStream:input] build];
}
+ (RpcFinished*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (RpcFinished*)[[[RpcFinished builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (RpcFinished*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (RpcFinished*)[[[RpcFinished builder] mergeFromCodedInputStream:input] build];
}
+ (RpcFinished*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (RpcFinished*)[[[RpcFinished builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (RpcFinished_Builder*) builder {
  return [[[RpcFinished_Builder alloc] init] autorelease];
}
+ (RpcFinished_Builder*) builderWithPrototype:(RpcFinished*) prototype {
  return [[RpcFinished builder] mergeFrom:prototype];
}
- (RpcFinished_Builder*) builder {
  return [RpcFinished builder];
}
@end

@interface RpcFinished_Builder()
@property (retain) RpcFinished* result;
@end

@implementation RpcFinished_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[RpcFinished alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (RpcFinished_Builder*) clear {
  self.result = [[[RpcFinished alloc] init] autorelease];
  return self;
}
- (RpcFinished_Builder*) clone {
  return [RpcFinished builderWithPrototype:result];
}
- (RpcFinished*) defaultInstance {
  return [RpcFinished defaultInstance];
}
- (RpcFinished*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (RpcFinished*) buildPartial {
  RpcFinished* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (RpcFinished_Builder*) mergeFrom:(RpcFinished*) other {
  if (other == [RpcFinished defaultInstance]) {
    return self;
  }
  if (other.hasFailed) {
    [self setFailed:other.failed];
  }
  if (other.hasErrorText) {
    [self setErrorText:other.errorText];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (RpcFinished_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (RpcFinished_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
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
      case 8: {
        [self setFailed:[input readBool]];
        break;
      }
      case 18: {
        [self setErrorText:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasFailed {
  return result.hasFailed;
}
- (BOOL) failed {
  return result.failed;
}
- (RpcFinished_Builder*) setFailed:(BOOL) value {
  result.hasFailed = YES;
  result.failed = value;
  return self;
}
- (RpcFinished_Builder*) clearFailed {
  result.hasFailed = NO;
  result.failed = NO;
  return self;
}
- (BOOL) hasErrorText {
  return result.hasErrorText;
}
- (NSString*) errorText {
  return result.errorText;
}
- (RpcFinished_Builder*) setErrorText:(NSString*) value {
  result.hasErrorText = YES;
  result.errorText = value;
  return self;
}
- (RpcFinished_Builder*) clearErrorText {
  result.hasErrorText = NO;
  result.errorText = @"";
  return self;
}
@end

