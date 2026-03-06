// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxCommon/MBXGeofencingUtilsUserConsentResponseCallback_Internal.h>

NS_SWIFT_NAME(__GeofencingUtils)
__attribute__((visibility ("default")))
@interface MBXGeofencingUtils : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

+ (void)setUserConsentForIsConsentGiven:(BOOL)isConsentGiven
                               callback:(nonnull MBXGeofencingUtilsUserConsentResponseCallback)callback
__attribute__((swift_name("setUserConsent(isConsentGiven:callback:)")));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Get the Geofencing user consent state.
 *
 * @return `true` if end-user has given consent of Geofencing, `false` otherwise.
 */
+ (BOOL)getUserConsent
__attribute__((swift_name("getUserConsent()")));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Get status of Geofencing.
 *
 * @return `true` if Geofencing is currently active and monitoring geofences.
 */
+ (BOOL)isActive
__attribute__((swift_name("isActive()")));

@end
