// This file is generated and will be overwritten automatically.

#import <MapboxCoreMaps/MBMViewAnnotationPositionDescriptor.h>

@interface MBMViewAnnotationPositionDescriptor ()
- (nonnull instancetype)initWithIdentifier:(nonnull NSString *)identifier
                                     width:(double)width
                                    height:(double)height
                         leftTopCoordinate:(nonnull MBMScreenCoordinate *)leftTopCoordinate
                          anchorCoordinate:(CLLocationCoordinate2D)anchorCoordinate
                              anchorConfig:(nonnull MBMViewAnnotationAnchorConfig *)anchorConfig NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Left-top screen coordinate in `platform pixels` for view annotation.
 */
@property (nonatomic, readonly, nonnull) MBMScreenCoordinate *leftTopCoordinate;

@end
