// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@protocol MBXGeofencingService;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * A factory class used to instantiate a Geofencing API object.
 */
NS_SWIFT_NAME(__GeofencingFactory)
__attribute__((visibility ("default")))
@interface MBXGeofencingFactory : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * A method used to instantiate a Geofencing API object.
 *
 * NOTE: User must have granted location permissions before calling this method.
 *
 * @return An instance of the GeofencingService.
 */
+ (nonnull id<MBXGeofencingService>)getOrCreate __attribute((ns_returns_retained))
__attribute__((swift_name("getOrCreate()")));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Releases the Geofencing API object.
 *
 * The strong reference from the factory to a custom implementation will be released. This can be
 * used to release the implementation once it is no longer needed. It may otherwise be kept until
 * the end of the program.
 */
+ (void)reset
__attribute__((swift_name("reset()")));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Replaces the default Geofencing API implementation with a custom one.
 *
 * If a default implementation has been created or a previous user defined implementation has been set already,
 * it will be replaced. The factory maintains a strong reference to the provided implementation
 * which can be released with the reset() method.
 */
+ (void)setUserDefinedForCustom:(nonnull id<MBXGeofencingService>)custom
__attribute__((swift_name("setUserDefined(custom:)")));

@end
