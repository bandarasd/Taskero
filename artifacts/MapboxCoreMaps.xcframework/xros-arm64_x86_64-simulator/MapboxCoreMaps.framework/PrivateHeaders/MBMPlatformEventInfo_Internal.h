// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxCoreMaps/MBMPlatformEventType_Internal.h>

@class MBMScreenCoordinate;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Represents the information that a platform SDK passes to the to dispatch the event.
 */
NS_SWIFT_NAME(PlatformEventInfo)
__attribute__((visibility ("default")))
@interface MBMPlatformEventInfo : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithType:(MBMPlatformEventType)type
                    screenCoordinate:(nonnull MBMScreenCoordinate *)screenCoordinate;

@property (nonatomic, readonly) MBMPlatformEventType type;
@property (nonatomic, readonly, nonnull) MBMScreenCoordinate *screenCoordinate;

@end
