// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Configuration options affecting the behavior of the geofencing service.
 */
NS_SWIFT_NAME(__GeofencingOptions)
__attribute__((visibility ("default")))
@interface MBXGeofencingOptions : NSObject

- (nonnull instancetype)init;

- (nonnull instancetype)initWithMaximumMonitoredFeatures:(uint32_t)maximumMonitoredFeatures;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * The maximum amount of monitored features.
 *
 * Default value is 100000
 */
@property (nonatomic, readonly) uint32_t maximumMonitoredFeatures;


@end
