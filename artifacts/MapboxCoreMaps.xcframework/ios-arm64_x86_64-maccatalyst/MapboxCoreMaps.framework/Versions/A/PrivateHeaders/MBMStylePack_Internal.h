// This file is generated and will be overwritten automatically.

#import <MapboxCoreMaps/MBMStylePack.h>

@interface MBMStylePack ()
- (nonnull instancetype)initWithStyleURI:(nonnull NSString *)styleURI
                 glyphsRasterizationMode:(MBMGlyphsRasterizationMode)glyphsRasterizationMode
                   requiredResourceCount:(uint64_t)requiredResourceCount
                  completedResourceCount:(uint64_t)completedResourceCount
                   completedResourceSize:(uint64_t)completedResourceSize
                                 expires:(nullable NSDate *)expires
                               extraData:(nullable id)extraData;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Reserved for future extensions.
 */
@property (nonatomic, readonly, nullable, copy) id extraData;

@end
