// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapboxCommon/MBXNetworkRestriction.h>
@class MBXCoordinate2D;

/** Describes the tile region load option values. */
NS_SWIFT_NAME(TileRegionApplyUpdateOptions)
__attribute__((visibility ("default")))
@interface MBXTileRegionApplyUpdateOptions : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

/**
 * Controls which networks may be used to fix update application issues.
 *
 * On normal conditions, applying an update should not require network usage. However, if the update cannot be
 * completely applied due to missing or incomplete data, this option specify which networks can be used to fetch
 * the missing resources. By default, only non-metered networks are allowed.
 */
@property (nonatomic, readwrite) MBXNetworkRestriction networkRestriction;

/**
 * Starts applying the tile region update at the given location and then proceeds to tiles that are further away
 * from it.
 */
@property (nonatomic, readwrite, nullable) MBXCoordinate2D *startLocation;

/** Creates a TileRegionApplyUpdateOptions instance with default options. */
+ (nonnull MBXTileRegionApplyUpdateOptions *)make __attribute((ns_returns_retained));

@end
