// This file is generated and will be overwritten automatically.

#import <MapboxCoreMaps/MBMQueriedRenderedFeature.h>

@interface MBMQueriedRenderedFeature ()
- (nonnull instancetype)initWithQueriedFeature:(nonnull MBMQueriedFeature *)queriedFeature
                                        layers:(nonnull NSArray<NSString *> *)layers
                                       targets:(nonnull NSArray<MBMFeaturesetQueryTarget *> *)targets NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * An array of feature query targets that correspond to this queried feature.
 *
 * Note: Returned query targets will omit the original filter data.
 */
@property (nonatomic, readonly, nonnull, copy) NSArray<MBMFeaturesetQueryTarget *> *targets NS_REFINED_FOR_SWIFT;

@end
