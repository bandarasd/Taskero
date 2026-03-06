// This file is generated and will be overwritten automatically.

#import <MapboxCoreMaps/MBMQueriedFeature.h>

@interface MBMQueriedFeature ()
- (nonnull instancetype)initWithFeature:(nonnull MBXFeature *)feature
                                 source:(nonnull NSString *)source
                            sourceLayer:(nullable NSString *)sourceLayer
                                  state:(nonnull id)state
                    featuresetFeatureId:(nullable MBMFeaturesetFeatureId *)featuresetFeatureId NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * An optional unique identifier for a feature when queried from a featureset.
 * If `featuresetFeatureId` is defined, it provides a unique reference to the feature within the featureset.
 * If the feature is not associated with a featureset, this field will be null. In such cases, use the `id` from `Feature` instead.
 *
 * Note: Use `FeaturesetFeatureId` instead of the `id` from `Feature` for operations related to followed feature query or feature states calls to ensure accurate and effective operations.
 */
@property (nonatomic, readonly, nullable) MBMFeaturesetFeatureId *featuresetFeatureId;

@end
