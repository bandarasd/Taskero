// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxCommon/MBXRegionMonitorErrorCode_Internal.h>

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Error information for region monitoring operations.
 */
NS_SWIFT_NAME(RegionMonitorError)
__attribute__((visibility ("default")))
@interface MBXRegionMonitorError : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithCode:(MBXRegionMonitorErrorCode)code
                             message:(nonnull NSString *)message;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * The code of the error.
 */
@property (nonatomic, readonly) MBXRegionMonitorErrorCode code;

/** Brief description of the error. */
@property (nonatomic, readonly, nonnull, copy) NSString *message;


@end
