// This file is generated and will be overwritten automatically.

#import <MapboxCoreMaps/MBMCameraChanged.h>

@interface MBMCameraChanged ()
- (nonnull instancetype)initWithCameraState:(nonnull MBMCameraState *)cameraState
                                  timestamp:(nonnull NSDate *)timestamp NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * The current state of the camera.
 */
@property (nonatomic, readonly, nonnull) MBMCameraState *cameraState NS_REFINED_FOR_SWIFT;

@end
