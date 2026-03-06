// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
@class MBXFeature;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Geofencing state for the feature.
 */
NS_SWIFT_NAME(__GeofenceState)
__attribute__((visibility ("default")))
@interface MBXGeofenceState : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithFeature:(nonnull MBXFeature *)feature
                              timestamp:(nullable NSDate *)timestamp;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * The feature linked to this event
 */
@property (nonatomic, readonly, nonnull) MBXFeature *feature;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * The time when the geofence was activated. Null if the user is not within the geofence.
 */
@property (nonatomic, readonly, nullable) NSDate *timestamp;


@end
