// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxCommon/MBXResultCallback_Internal.h>

@class MBXExperimentalWssBackendData;
@class MBXExperimentalWssBackendRequest;
@protocol MBXExperimentalWssBackendRequestObserver;

NS_SWIFT_NAME(Service)
@protocol MBXExperimentalWssBackendService
/** Set ping timeout to use for all newly created sessions. */
- (void)setPingTimeoutForPingTimeout:(NSTimeInterval)pingTimeout;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Make a WSS connection request. The provided callback is invoked upon completion or error.
 */
- (uint64_t)connectForRequest:(nonnull MBXExperimentalWssBackendRequest *)request
                     observer:(nonnull id<MBXExperimentalWssBackendRequestObserver>)observer;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Cancel connection.
 */
- (void)cancelConnectionForId:(uint64_t)id_
                     callback:(nonnull MBXResultCallback)callback;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Write data to an open connection.
 */
- (void)writeForId:(uint64_t)id_
              data:(nonnull MBXExperimentalWssBackendData *)data;
@end
