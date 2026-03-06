// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxCoreMaps/MBMInteractionType_Internal.h>

@class MBMFeaturesetDescriptor;
@protocol MBMInteractionHandler;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Represents the interaction object. Use this object to add interatin to the map via `Map.addInteraction` method.
 */
NS_SWIFT_NAME(Interaction)
__attribute__((visibility ("default")))
@interface MBMInteraction : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithFeatureset:(nullable MBMFeaturesetDescriptor *)featureset
                                    filter:(nullable id)filter
                                      type:(MBMInteractionType)type
                                   handler:(nonnull id<MBMInteractionHandler>)handler
                                    radius:(nullable NSNumber *)radius;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * A featureset to add interaction to.
 */
@property (nonatomic, readonly, nullable) MBMFeaturesetDescriptor *featureset;

/**
 * A filter allows to specify which features from the featureset should handle the interaction.
 * This parameter only applies when the featureset is specified.
 */
@property (nonatomic, readonly, nullable, copy) id filter;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * A type of interaction.
 */
@property (nonatomic, readonly) MBMInteractionType type;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * An interaction handler object.
 */
@property (nonatomic, readonly, nonnull) id<MBMInteractionHandler> handler;

/**
 * Radius of an extra area around touch in screen pixels. Default value: 0.
 * This parameter only applies when the featureset is specified.
 */
@property (nonatomic, readonly, nullable) NSNumber *radius;


@end
