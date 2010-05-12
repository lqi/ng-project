// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

#import "Descriptor.pb.h"

@class DescriptorProto;
@class DescriptorProto_Builder;
@class DescriptorProto_ExtensionRange;
@class DescriptorProto_ExtensionRange_Builder;
@class EnumDescriptorProto;
@class EnumDescriptorProto_Builder;
@class EnumOptions;
@class EnumOptions_Builder;
@class EnumValueDescriptorProto;
@class EnumValueDescriptorProto_Builder;
@class EnumValueOptions;
@class EnumValueOptions_Builder;
@class FieldDescriptorProto;
@class FieldDescriptorProto_Builder;
@class FieldOptions;
@class FieldOptions_Builder;
@class FileDescriptorProto;
@class FileDescriptorProto_Builder;
@class FileDescriptorSet;
@class FileDescriptorSet_Builder;
@class FileOptions;
@class FileOptions_Builder;
@class MessageOptions;
@class MessageOptions_Builder;
@class MethodDescriptorProto;
@class MethodDescriptorProto_Builder;
@class MethodOptions;
@class MethodOptions_Builder;
@class ObjectiveCFileOptions;
@class ObjectiveCFileOptions_Builder;
@class ServiceDescriptorProto;
@class ServiceDescriptorProto_Builder;
@class ServiceOptions;
@class ServiceOptions_Builder;
@class UninterpretedOption;
@class UninterpretedOption_Builder;
@class UninterpretedOption_NamePart;
@class UninterpretedOption_NamePart_Builder;

@interface ObjectivecDescriptorRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
+ (id<PBExtensionField>) objectivecFileOptions;
@end

@interface ObjectiveCFileOptions : PBGeneratedMessage {
@private
  BOOL hasPackage_:1;
  BOOL hasClassPrefix_:1;
  NSString* package;
  NSString* classPrefix;
}
- (BOOL) hasPackage;
- (BOOL) hasClassPrefix;
@property (readonly, retain) NSString* package;
@property (readonly, retain) NSString* classPrefix;

+ (ObjectiveCFileOptions*) defaultInstance;
- (ObjectiveCFileOptions*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (ObjectiveCFileOptions_Builder*) builder;
+ (ObjectiveCFileOptions_Builder*) builder;
+ (ObjectiveCFileOptions_Builder*) builderWithPrototype:(ObjectiveCFileOptions*) prototype;

+ (ObjectiveCFileOptions*) parseFromData:(NSData*) data;
+ (ObjectiveCFileOptions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ObjectiveCFileOptions*) parseFromInputStream:(NSInputStream*) input;
+ (ObjectiveCFileOptions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ObjectiveCFileOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (ObjectiveCFileOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface ObjectiveCFileOptions_Builder : PBGeneratedMessage_Builder {
@private
  ObjectiveCFileOptions* result;
}

- (ObjectiveCFileOptions*) defaultInstance;

- (ObjectiveCFileOptions_Builder*) clear;
- (ObjectiveCFileOptions_Builder*) clone;

- (ObjectiveCFileOptions*) build;
- (ObjectiveCFileOptions*) buildPartial;

- (ObjectiveCFileOptions_Builder*) mergeFrom:(ObjectiveCFileOptions*) other;
- (ObjectiveCFileOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (ObjectiveCFileOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasPackage;
- (NSString*) package;
- (ObjectiveCFileOptions_Builder*) setPackage:(NSString*) value;
- (ObjectiveCFileOptions_Builder*) clearPackage;

- (BOOL) hasClassPrefix;
- (NSString*) classPrefix;
- (ObjectiveCFileOptions_Builder*) setClassPrefix:(NSString*) value;
- (ObjectiveCFileOptions_Builder*) clearClassPrefix;
@end
