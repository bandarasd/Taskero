// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
@class MBXFeature;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Geofencing event created onEntry/onDwell/onExit.
 */
NS_SWIFT_NAME(__GeofencingEvent)
__attribute__((visibility ("default")))
@interface MBXGeofencingEvent : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithFeature:(nonnull MBXFeature *)feature
                              timestamp:(nonnull NSDate *)timestamp;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * The feature linked to this event
 */
@property (nonatomic, readonly, nonnull) MBXFeature *feature;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * The time of this event.
 */
@property (nonatomic, readonly, nonnull) NSDate *timestamp;


@end
