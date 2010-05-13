// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

#import "Rpc.pb.h"
#import "Federation.pb.h"

@class CancelRpc;
@class CancelRpc_Builder;
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
@class ProtocolAppliedWaveletDelta;
@class ProtocolAppliedWaveletDelta_Builder;
@class ProtocolDocumentOperation;
@class ProtocolDocumentOperation_Builder;
@class ProtocolDocumentOperation_Component;
@class ProtocolDocumentOperation_Component_AnnotationBoundary;
@class ProtocolDocumentOperation_Component_AnnotationBoundary_Builder;
@class ProtocolDocumentOperation_Component_Builder;
@class ProtocolDocumentOperation_Component_ElementStart;
@class ProtocolDocumentOperation_Component_ElementStart_Builder;
@class ProtocolDocumentOperation_Component_KeyValuePair;
@class ProtocolDocumentOperation_Component_KeyValuePair_Builder;
@class ProtocolDocumentOperation_Component_KeyValueUpdate;
@class ProtocolDocumentOperation_Component_KeyValueUpdate_Builder;
@class ProtocolDocumentOperation_Component_ReplaceAttributes;
@class ProtocolDocumentOperation_Component_ReplaceAttributes_Builder;
@class ProtocolDocumentOperation_Component_UpdateAttributes;
@class ProtocolDocumentOperation_Component_UpdateAttributes_Builder;
@class ProtocolHashedVersion;
@class ProtocolHashedVersion_Builder;
@class ProtocolOpenRequest;
@class ProtocolOpenRequest_Builder;
@class ProtocolSignature;
@class ProtocolSignature_Builder;
@class ProtocolSignedDelta;
@class ProtocolSignedDelta_Builder;
@class ProtocolSignerInfo;
@class ProtocolSignerInfo_Builder;
@class ProtocolSubmitRequest;
@class ProtocolSubmitRequest_Builder;
@class ProtocolSubmitResponse;
@class ProtocolSubmitResponse_Builder;
@class ProtocolWaveletDelta;
@class ProtocolWaveletDelta_Builder;
@class ProtocolWaveletOperation;
@class ProtocolWaveletOperation_Builder;
@class ProtocolWaveletOperation_MutateDocument;
@class ProtocolWaveletOperation_MutateDocument_Builder;
@class ProtocolWaveletUpdate;
@class ProtocolWaveletUpdate_Builder;
@class RpcFinished;
@class RpcFinished_Builder;
@class ServiceDescriptorProto;
@class ServiceDescriptorProto_Builder;
@class ServiceOptions;
@class ServiceOptions_Builder;
@class UninterpretedOption;
@class UninterpretedOption_Builder;
@class UninterpretedOption_NamePart;
@class UninterpretedOption_NamePart_Builder;
@class WaveletSnapshot;
@class WaveletSnapshot_Builder;
@class WaveletSnapshot_DocumentSnapshot;
@class WaveletSnapshot_DocumentSnapshot_Builder;

@interface WaveclientRpcRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface ProtocolOpenRequest : PBGeneratedMessage {
@private
  BOOL hasSnapshots_:1;
  BOOL hasMaximumWavelets_:1;
  BOOL hasParticipantId_:1;
  BOOL hasWaveId_:1;
  BOOL snapshots_:1;
  int32_t maximumWavelets;
  NSString* participantId;
  NSString* waveId;
  NSMutableArray* mutableWaveletIdPrefixList;
}
- (BOOL) hasParticipantId;
- (BOOL) hasWaveId;
- (BOOL) hasMaximumWavelets;
- (BOOL) hasSnapshots;
@property (readonly, retain) NSString* participantId;
@property (readonly, retain) NSString* waveId;
@property (readonly) int32_t maximumWavelets;
- (BOOL) snapshots;
- (NSArray*) waveletIdPrefixList;
- (NSString*) waveletIdPrefixAtIndex:(int32_t) index;

+ (ProtocolOpenRequest*) defaultInstance;
- (ProtocolOpenRequest*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (ProtocolOpenRequest_Builder*) builder;
+ (ProtocolOpenRequest_Builder*) builder;
+ (ProtocolOpenRequest_Builder*) builderWithPrototype:(ProtocolOpenRequest*) prototype;

+ (ProtocolOpenRequest*) parseFromData:(NSData*) data;
+ (ProtocolOpenRequest*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ProtocolOpenRequest*) parseFromInputStream:(NSInputStream*) input;
+ (ProtocolOpenRequest*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ProtocolOpenRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (ProtocolOpenRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface ProtocolOpenRequest_Builder : PBGeneratedMessage_Builder {
@private
  ProtocolOpenRequest* result;
}

- (ProtocolOpenRequest*) defaultInstance;

- (ProtocolOpenRequest_Builder*) clear;
- (ProtocolOpenRequest_Builder*) clone;

- (ProtocolOpenRequest*) build;
- (ProtocolOpenRequest*) buildPartial;

- (ProtocolOpenRequest_Builder*) mergeFrom:(ProtocolOpenRequest*) other;
- (ProtocolOpenRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (ProtocolOpenRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasParticipantId;
- (NSString*) participantId;
- (ProtocolOpenRequest_Builder*) setParticipantId:(NSString*) value;
- (ProtocolOpenRequest_Builder*) clearParticipantId;

- (BOOL) hasWaveId;
- (NSString*) waveId;
- (ProtocolOpenRequest_Builder*) setWaveId:(NSString*) value;
- (ProtocolOpenRequest_Builder*) clearWaveId;

- (NSArray*) waveletIdPrefixList;
- (NSString*) waveletIdPrefixAtIndex:(int32_t) index;
- (ProtocolOpenRequest_Builder*) replaceWaveletIdPrefixAtIndex:(int32_t) index with:(NSString*) value;
- (ProtocolOpenRequest_Builder*) addWaveletIdPrefix:(NSString*) value;
- (ProtocolOpenRequest_Builder*) addAllWaveletIdPrefix:(NSArray*) values;
- (ProtocolOpenRequest_Builder*) clearWaveletIdPrefixList;

- (BOOL) hasMaximumWavelets;
- (int32_t) maximumWavelets;
- (ProtocolOpenRequest_Builder*) setMaximumWavelets:(int32_t) value;
- (ProtocolOpenRequest_Builder*) clearMaximumWavelets;

- (BOOL) hasSnapshots;
- (BOOL) snapshots;
- (ProtocolOpenRequest_Builder*) setSnapshots:(BOOL) value;
- (ProtocolOpenRequest_Builder*) clearSnapshots;
@end

@interface WaveletSnapshot : PBGeneratedMessage {
@private
  NSMutableArray* mutableParticipantIdList;
  NSMutableArray* mutableDocumentList;
}
- (NSArray*) participantIdList;
- (NSString*) participantIdAtIndex:(int32_t) index;
- (NSArray*) documentList;
- (WaveletSnapshot_DocumentSnapshot*) documentAtIndex:(int32_t) index;

+ (WaveletSnapshot*) defaultInstance;
- (WaveletSnapshot*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (WaveletSnapshot_Builder*) builder;
+ (WaveletSnapshot_Builder*) builder;
+ (WaveletSnapshot_Builder*) builderWithPrototype:(WaveletSnapshot*) prototype;

+ (WaveletSnapshot*) parseFromData:(NSData*) data;
+ (WaveletSnapshot*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (WaveletSnapshot*) parseFromInputStream:(NSInputStream*) input;
+ (WaveletSnapshot*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (WaveletSnapshot*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (WaveletSnapshot*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface WaveletSnapshot_DocumentSnapshot : PBGeneratedMessage {
@private
  BOOL hasDocumentId_:1;
  BOOL hasDocumentOperation_:1;
  NSString* documentId;
  ProtocolDocumentOperation* documentOperation;
}
- (BOOL) hasDocumentId;
- (BOOL) hasDocumentOperation;
@property (readonly, retain) NSString* documentId;
@property (readonly, retain) ProtocolDocumentOperation* documentOperation;

+ (WaveletSnapshot_DocumentSnapshot*) defaultInstance;
- (WaveletSnapshot_DocumentSnapshot*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (WaveletSnapshot_DocumentSnapshot_Builder*) builder;
+ (WaveletSnapshot_DocumentSnapshot_Builder*) builder;
+ (WaveletSnapshot_DocumentSnapshot_Builder*) builderWithPrototype:(WaveletSnapshot_DocumentSnapshot*) prototype;

+ (WaveletSnapshot_DocumentSnapshot*) parseFromData:(NSData*) data;
+ (WaveletSnapshot_DocumentSnapshot*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (WaveletSnapshot_DocumentSnapshot*) parseFromInputStream:(NSInputStream*) input;
+ (WaveletSnapshot_DocumentSnapshot*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (WaveletSnapshot_DocumentSnapshot*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (WaveletSnapshot_DocumentSnapshot*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface WaveletSnapshot_DocumentSnapshot_Builder : PBGeneratedMessage_Builder {
@private
  WaveletSnapshot_DocumentSnapshot* result;
}

- (WaveletSnapshot_DocumentSnapshot*) defaultInstance;

- (WaveletSnapshot_DocumentSnapshot_Builder*) clear;
- (WaveletSnapshot_DocumentSnapshot_Builder*) clone;

- (WaveletSnapshot_DocumentSnapshot*) build;
- (WaveletSnapshot_DocumentSnapshot*) buildPartial;

- (WaveletSnapshot_DocumentSnapshot_Builder*) mergeFrom:(WaveletSnapshot_DocumentSnapshot*) other;
- (WaveletSnapshot_DocumentSnapshot_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (WaveletSnapshot_DocumentSnapshot_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasDocumentId;
- (NSString*) documentId;
- (WaveletSnapshot_DocumentSnapshot_Builder*) setDocumentId:(NSString*) value;
- (WaveletSnapshot_DocumentSnapshot_Builder*) clearDocumentId;

- (BOOL) hasDocumentOperation;
- (ProtocolDocumentOperation*) documentOperation;
- (WaveletSnapshot_DocumentSnapshot_Builder*) setDocumentOperation:(ProtocolDocumentOperation*) value;
- (WaveletSnapshot_DocumentSnapshot_Builder*) setDocumentOperationBuilder:(ProtocolDocumentOperation_Builder*) builderForValue;
- (WaveletSnapshot_DocumentSnapshot_Builder*) mergeDocumentOperation:(ProtocolDocumentOperation*) value;
- (WaveletSnapshot_DocumentSnapshot_Builder*) clearDocumentOperation;
@end

@interface WaveletSnapshot_Builder : PBGeneratedMessage_Builder {
@private
  WaveletSnapshot* result;
}

- (WaveletSnapshot*) defaultInstance;

- (WaveletSnapshot_Builder*) clear;
- (WaveletSnapshot_Builder*) clone;

- (WaveletSnapshot*) build;
- (WaveletSnapshot*) buildPartial;

- (WaveletSnapshot_Builder*) mergeFrom:(WaveletSnapshot*) other;
- (WaveletSnapshot_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (WaveletSnapshot_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (NSArray*) participantIdList;
- (NSString*) participantIdAtIndex:(int32_t) index;
- (WaveletSnapshot_Builder*) replaceParticipantIdAtIndex:(int32_t) index with:(NSString*) value;
- (WaveletSnapshot_Builder*) addParticipantId:(NSString*) value;
- (WaveletSnapshot_Builder*) addAllParticipantId:(NSArray*) values;
- (WaveletSnapshot_Builder*) clearParticipantIdList;

- (NSArray*) documentList;
- (WaveletSnapshot_DocumentSnapshot*) documentAtIndex:(int32_t) index;
- (WaveletSnapshot_Builder*) replaceDocumentAtIndex:(int32_t) index with:(WaveletSnapshot_DocumentSnapshot*) value;
- (WaveletSnapshot_Builder*) addDocument:(WaveletSnapshot_DocumentSnapshot*) value;
- (WaveletSnapshot_Builder*) addAllDocument:(NSArray*) values;
- (WaveletSnapshot_Builder*) clearDocumentList;
@end

@interface ProtocolWaveletUpdate : PBGeneratedMessage {
@private
  BOOL hasWaveletName_:1;
  BOOL hasCommitNotice_:1;
  BOOL hasResultingVersion_:1;
  BOOL hasSnapshot_:1;
  NSString* waveletName;
  ProtocolHashedVersion* commitNotice;
  ProtocolHashedVersion* resultingVersion;
  WaveletSnapshot* snapshot;
  NSMutableArray* mutableAppliedDeltaList;
}
- (BOOL) hasWaveletName;
- (BOOL) hasCommitNotice;
- (BOOL) hasResultingVersion;
- (BOOL) hasSnapshot;
@property (readonly, retain) NSString* waveletName;
@property (readonly, retain) ProtocolHashedVersion* commitNotice;
@property (readonly, retain) ProtocolHashedVersion* resultingVersion;
@property (readonly, retain) WaveletSnapshot* snapshot;
- (NSArray*) appliedDeltaList;
- (ProtocolWaveletDelta*) appliedDeltaAtIndex:(int32_t) index;

+ (ProtocolWaveletUpdate*) defaultInstance;
- (ProtocolWaveletUpdate*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (ProtocolWaveletUpdate_Builder*) builder;
+ (ProtocolWaveletUpdate_Builder*) builder;
+ (ProtocolWaveletUpdate_Builder*) builderWithPrototype:(ProtocolWaveletUpdate*) prototype;

+ (ProtocolWaveletUpdate*) parseFromData:(NSData*) data;
+ (ProtocolWaveletUpdate*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ProtocolWaveletUpdate*) parseFromInputStream:(NSInputStream*) input;
+ (ProtocolWaveletUpdate*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ProtocolWaveletUpdate*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (ProtocolWaveletUpdate*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface ProtocolWaveletUpdate_Builder : PBGeneratedMessage_Builder {
@private
  ProtocolWaveletUpdate* result;
}

- (ProtocolWaveletUpdate*) defaultInstance;

- (ProtocolWaveletUpdate_Builder*) clear;
- (ProtocolWaveletUpdate_Builder*) clone;

- (ProtocolWaveletUpdate*) build;
- (ProtocolWaveletUpdate*) buildPartial;

- (ProtocolWaveletUpdate_Builder*) mergeFrom:(ProtocolWaveletUpdate*) other;
- (ProtocolWaveletUpdate_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (ProtocolWaveletUpdate_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasWaveletName;
- (NSString*) waveletName;
- (ProtocolWaveletUpdate_Builder*) setWaveletName:(NSString*) value;
- (ProtocolWaveletUpdate_Builder*) clearWaveletName;

- (NSArray*) appliedDeltaList;
- (ProtocolWaveletDelta*) appliedDeltaAtIndex:(int32_t) index;
- (ProtocolWaveletUpdate_Builder*) replaceAppliedDeltaAtIndex:(int32_t) index with:(ProtocolWaveletDelta*) value;
- (ProtocolWaveletUpdate_Builder*) addAppliedDelta:(ProtocolWaveletDelta*) value;
- (ProtocolWaveletUpdate_Builder*) addAllAppliedDelta:(NSArray*) values;
- (ProtocolWaveletUpdate_Builder*) clearAppliedDeltaList;

- (BOOL) hasCommitNotice;
- (ProtocolHashedVersion*) commitNotice;
- (ProtocolWaveletUpdate_Builder*) setCommitNotice:(ProtocolHashedVersion*) value;
- (ProtocolWaveletUpdate_Builder*) setCommitNoticeBuilder:(ProtocolHashedVersion_Builder*) builderForValue;
- (ProtocolWaveletUpdate_Builder*) mergeCommitNotice:(ProtocolHashedVersion*) value;
- (ProtocolWaveletUpdate_Builder*) clearCommitNotice;

- (BOOL) hasResultingVersion;
- (ProtocolHashedVersion*) resultingVersion;
- (ProtocolWaveletUpdate_Builder*) setResultingVersion:(ProtocolHashedVersion*) value;
- (ProtocolWaveletUpdate_Builder*) setResultingVersionBuilder:(ProtocolHashedVersion_Builder*) builderForValue;
- (ProtocolWaveletUpdate_Builder*) mergeResultingVersion:(ProtocolHashedVersion*) value;
- (ProtocolWaveletUpdate_Builder*) clearResultingVersion;

- (BOOL) hasSnapshot;
- (WaveletSnapshot*) snapshot;
- (ProtocolWaveletUpdate_Builder*) setSnapshot:(WaveletSnapshot*) value;
- (ProtocolWaveletUpdate_Builder*) setSnapshotBuilder:(WaveletSnapshot_Builder*) builderForValue;
- (ProtocolWaveletUpdate_Builder*) mergeSnapshot:(WaveletSnapshot*) value;
- (ProtocolWaveletUpdate_Builder*) clearSnapshot;
@end

@interface ProtocolSubmitRequest : PBGeneratedMessage {
@private
  BOOL hasWaveletName_:1;
  BOOL hasDelta_:1;
  NSString* waveletName;
  ProtocolWaveletDelta* delta;
}
- (BOOL) hasWaveletName;
- (BOOL) hasDelta;
@property (readonly, retain) NSString* waveletName;
@property (readonly, retain) ProtocolWaveletDelta* delta;

+ (ProtocolSubmitRequest*) defaultInstance;
- (ProtocolSubmitRequest*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (ProtocolSubmitRequest_Builder*) builder;
+ (ProtocolSubmitRequest_Builder*) builder;
+ (ProtocolSubmitRequest_Builder*) builderWithPrototype:(ProtocolSubmitRequest*) prototype;

+ (ProtocolSubmitRequest*) parseFromData:(NSData*) data;
+ (ProtocolSubmitRequest*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ProtocolSubmitRequest*) parseFromInputStream:(NSInputStream*) input;
+ (ProtocolSubmitRequest*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ProtocolSubmitRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (ProtocolSubmitRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface ProtocolSubmitRequest_Builder : PBGeneratedMessage_Builder {
@private
  ProtocolSubmitRequest* result;
}

- (ProtocolSubmitRequest*) defaultInstance;

- (ProtocolSubmitRequest_Builder*) clear;
- (ProtocolSubmitRequest_Builder*) clone;

- (ProtocolSubmitRequest*) build;
- (ProtocolSubmitRequest*) buildPartial;

- (ProtocolSubmitRequest_Builder*) mergeFrom:(ProtocolSubmitRequest*) other;
- (ProtocolSubmitRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (ProtocolSubmitRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasWaveletName;
- (NSString*) waveletName;
- (ProtocolSubmitRequest_Builder*) setWaveletName:(NSString*) value;
- (ProtocolSubmitRequest_Builder*) clearWaveletName;

- (BOOL) hasDelta;
- (ProtocolWaveletDelta*) delta;
- (ProtocolSubmitRequest_Builder*) setDelta:(ProtocolWaveletDelta*) value;
- (ProtocolSubmitRequest_Builder*) setDeltaBuilder:(ProtocolWaveletDelta_Builder*) builderForValue;
- (ProtocolSubmitRequest_Builder*) mergeDelta:(ProtocolWaveletDelta*) value;
- (ProtocolSubmitRequest_Builder*) clearDelta;
@end

@interface ProtocolSubmitResponse : PBGeneratedMessage {
@private
  BOOL hasOperationsApplied_:1;
  BOOL hasErrorMessage_:1;
  BOOL hasHashedVersionAfterApplication_:1;
  int32_t operationsApplied;
  NSString* errorMessage;
  ProtocolHashedVersion* hashedVersionAfterApplication;
}
- (BOOL) hasOperationsApplied;
- (BOOL) hasErrorMessage;
- (BOOL) hasHashedVersionAfterApplication;
@property (readonly) int32_t operationsApplied;
@property (readonly, retain) NSString* errorMessage;
@property (readonly, retain) ProtocolHashedVersion* hashedVersionAfterApplication;

+ (ProtocolSubmitResponse*) defaultInstance;
- (ProtocolSubmitResponse*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (ProtocolSubmitResponse_Builder*) builder;
+ (ProtocolSubmitResponse_Builder*) builder;
+ (ProtocolSubmitResponse_Builder*) builderWithPrototype:(ProtocolSubmitResponse*) prototype;

+ (ProtocolSubmitResponse*) parseFromData:(NSData*) data;
+ (ProtocolSubmitResponse*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ProtocolSubmitResponse*) parseFromInputStream:(NSInputStream*) input;
+ (ProtocolSubmitResponse*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ProtocolSubmitResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (ProtocolSubmitResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface ProtocolSubmitResponse_Builder : PBGeneratedMessage_Builder {
@private
  ProtocolSubmitResponse* result;
}

- (ProtocolSubmitResponse*) defaultInstance;

- (ProtocolSubmitResponse_Builder*) clear;
- (ProtocolSubmitResponse_Builder*) clone;

- (ProtocolSubmitResponse*) build;
- (ProtocolSubmitResponse*) buildPartial;

- (ProtocolSubmitResponse_Builder*) mergeFrom:(ProtocolSubmitResponse*) other;
- (ProtocolSubmitResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (ProtocolSubmitResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasOperationsApplied;
- (int32_t) operationsApplied;
- (ProtocolSubmitResponse_Builder*) setOperationsApplied:(int32_t) value;
- (ProtocolSubmitResponse_Builder*) clearOperationsApplied;

- (BOOL) hasErrorMessage;
- (NSString*) errorMessage;
- (ProtocolSubmitResponse_Builder*) setErrorMessage:(NSString*) value;
- (ProtocolSubmitResponse_Builder*) clearErrorMessage;

- (BOOL) hasHashedVersionAfterApplication;
- (ProtocolHashedVersion*) hashedVersionAfterApplication;
- (ProtocolSubmitResponse_Builder*) setHashedVersionAfterApplication:(ProtocolHashedVersion*) value;
- (ProtocolSubmitResponse_Builder*) setHashedVersionAfterApplicationBuilder:(ProtocolHashedVersion_Builder*) builderForValue;
- (ProtocolSubmitResponse_Builder*) mergeHashedVersionAfterApplication:(ProtocolHashedVersion*) value;
- (ProtocolSubmitResponse_Builder*) clearHashedVersionAfterApplication;
@end

