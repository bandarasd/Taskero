// This file is generated and will be overwritten automatically.

#import <MapboxCoreMaps/MBMQueriedSourceFeature.h>

@interface MBMQueriedSourceFeature ()
- (nonnull instancetype)initWithQueriedFeature:(nonnull MBMQueriedFeature *)queriedFeature
                                        target:(nullable MBMFeaturesetQueryTarget *)target NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * FeaturesetQueryTarget that associates with this queried feature.
 *
 * Note: Returned query target will omit the original filter data.
 */
@property (nonatomic, readonly, nullable) MBMFeaturesetQueryTarget *target;

@end
