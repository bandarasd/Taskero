// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Geofencing error codes.
 */
// NOLINTNEXTLINE(modernize-use-using)
typedef NS_ENUM(NSInteger, MBXGeofencingErrorType)
{
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * Generic error.
     */
    MBXGeofencingErrorTypeGeneric,
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * Geofencing API object is not available.
     */
    MBXGeofencingErrorTypeNotAvailable,
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * Default radius is too large.
     */
    MBXGeofencingErrorTypeDefaultRadiusTooLarge,
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * Maximum amount of monitored features limit has been reached.
     */
    MBXGeofencingErrorTypeMonitoredFeaturesLimitReached,
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * Location Service API is unavailable.
     */
    MBXGeofencingErrorTypeLocationServiceUnavailable,
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * Location usage is not authorized by the user.
     */
    MBXGeofencingErrorTypeLocationServiceUnauthorized,
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * Location data is inaccurate.
     */
    MBXGeofencingErrorTypeLocationServiceInaccurate,
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * An error occurred in the device location provider.
     */
    MBXGeofencingErrorTypeDeviceLocationProviderError,
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * The given feature is already monitored.
     */
    MBXGeofencingErrorTypeFeatureAlreadyAdded,
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * The given feature is not being monitored.
     */
    MBXGeofencingErrorTypeFeatureNotFound,
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * The given feature is invalid.
     */
    MBXGeofencingErrorTypeFeatureInvalid,
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * The given geofence observer is already included.
     */
    MBXGeofencingErrorTypeObserverAlreadyAdded,
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * The given geofence observer is not found.
     */
    MBXGeofencingErrorTypeObserverNotFound,
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * The given feature could not be added to the permanent storage.
     */
    MBXGeofencingErrorTypeFeatureNotStored
} NS_SWIFT_NAME(__GeofencingErrorType);
