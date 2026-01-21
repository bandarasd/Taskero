// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxCommon/MBXGeofencingErrorType_Internal.h>

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Geofencing error code with brief explanation.
 */
NS_SWIFT_NAME(__GeofencingError)
__attribute__((visibility ("default")))
@interface MBXGeofencingError : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithType:(MBXGeofencingErrorType)type
                             message:(nonnull NSString *)message;

@property (nonatomic, readonly) MBXGeofencingErrorType type;
@property (nonatomic, readonly, nonnull, copy) NSString *message;

@end
