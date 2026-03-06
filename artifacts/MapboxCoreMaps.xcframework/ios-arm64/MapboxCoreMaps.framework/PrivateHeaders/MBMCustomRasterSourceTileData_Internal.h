// This file is generated and will be overwritten automatically.

#import <MapboxCoreMaps/MBMCustomRasterSourceTileData.h>

@interface MBMCustomRasterSourceTileData ()
- (nonnull instancetype)initWithTileId:(nonnull MBMCanonicalTileID *)tileId
                                 image:(nullable MBMImage *)image;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * `Image` content of the tile. If an empty image is provided then the tile gets removed from the map.
 */
@property (nonatomic, readonly, nullable) MBMImage *image NS_REFINED_FOR_SWIFT;

@end
