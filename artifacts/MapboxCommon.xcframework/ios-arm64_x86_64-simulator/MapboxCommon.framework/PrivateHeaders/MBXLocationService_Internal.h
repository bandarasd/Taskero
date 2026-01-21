// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxCommon/MBXAccuracyAuthorization.h>
#import <MapboxCommon/MBXPermissionStatus.h>
@class MBXExpected<__covariant Value, __covariant Error>;

@class MBXLocationError;
@class MBXLocationProviderRequest;
@protocol MBXDeviceLocationProvider;
@protocol MBXDeviceLocationProviderFactory;
@protocol MBXLocationServiceObserver;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * The entry point of the platform location services.
 */
NS_SWIFT_NAME(LocationService)
@protocol MBXLocationService
/**
 * Check if the platform location service is available
 *
 * Returns true if the platform service is available and
 * false if it's not (for example when the device does not
 * have GNSS unit or has location service turned off).
 */
- (BOOL)isAvailable;
/** Gets a current status of location permission of the app. */
- (MBXPermissionStatus)getPermissionStatus;
/** Gets a current accuracy authorization of the app */
- (MBXAccuracyAuthorization)getAccuracyAuthorization;
/**
 * Registers an observer. LocationService can have more than one observer.
 *
 * @param observer An observer to add.
 */
- (void)registerObserverForObserver:(nonnull id<MBXLocationServiceObserver>)observer;
/**
 * Removes observer. If the observer is not registered, this is no-op.
 *
 * @param observer An observer to remove.
 */
- (void)unregisterObserverForObserver:(nonnull id<MBXLocationServiceObserver>)observer;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Gets an instance of DeviceLocationProvider. In case user defined factory
 * was set by setUserDefinedDeviceLocationProviderFactory it will be asked to provide an instance.
 *
 * Note that it's up to the implementation to create a new instance
 * or reuse the existing one.
 *
 * @param request Settings for this instance of the client.
 *                 When request is not specified then reasonable default will be applied.
 *                 Unknown values in request should be omitted by implementation silently.
 *
 * @return Returns an instance of a device location provider
 *         or a error if it fails to instantiate it.
 */
- (nonnull MBXExpected<id<MBXDeviceLocationProvider>, MBXLocationError *> *)getDeviceLocationProviderForRequest:(nullable MBXLocationProviderRequest *)request;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Set factory to build user defined DeviceLocationProvider.
 * When set, this factory will intercept all getDeviceLocationProvider calls to provide an instance of a `DeviceLocationProvider`.
 *
 * When `null` is set, factory resets to the default one.
 *
 * @param factory to build DeviceLocationProvider
 */
- (void)setUserDefinedDeviceLocationProviderFactoryForFactory:(nullable id<MBXDeviceLocationProviderFactory>)factory;
@end
