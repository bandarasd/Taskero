// This file is generated and will be overwritten automatically.

#import <MapboxCoreMaps/MBMPerformanceStatisticsOptions.h>
#import <MapboxCoreMaps/MBMPerformanceSamplerOptions_Internal.h>

@interface MBMPerformanceStatisticsOptions ()
- (nonnull instancetype)initWithSamplerOptions:(nonnull NSArray<NSNumber *> *)samplerOptions
                        samplingDurationMillis:(double)samplingDurationMillis NS_REFINED_FOR_SWIFT;
- (nonnull instancetype)initWithSamplerOptions:(nonnull NSArray<NSNumber *> *)samplerOptions NS_REFINED_FOR_SWIFT;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * List of optional samplers to be used to collect performance statistics.
 * @see PerformanceSamplerOptions
 */
@property (nonatomic, readonly, nonnull, copy) NSArray<NSNumber *> *samplerOptions NS_REFINED_FOR_SWIFT;

@end
