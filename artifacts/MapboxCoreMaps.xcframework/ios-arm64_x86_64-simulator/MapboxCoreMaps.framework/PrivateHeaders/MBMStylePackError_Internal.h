// This file is generated and will be overwritten automatically.

#import <MapboxCoreMaps/MBMStylePackError.h>
#import <MapboxCoreMaps/MBMStylePackErrorType_Internal.h>

@interface MBMStylePackError ()
- (nonnull instancetype)initWithType:(MBMStylePackErrorType)type
                             message:(nonnull NSString *)message;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * The reason for the response error.
 */
@property (nonatomic, readonly) MBMStylePackErrorType type;

@end
