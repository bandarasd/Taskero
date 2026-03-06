// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * The distance on each side between rectangles, when one is contained into other.
 *
 * All fields' values are in `platform pixel` units.
 */
NS_SWIFT_NAME(EdgeInsets)
__attribute__((visibility ("default")))
@interface MBMEdgeInsets : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithTop:(double)top
                               left:(double)left
                             bottom:(double)bottom
                              right:(double)right;

/** Padding from the top. */
@property (nonatomic, readonly) double top;

/** Padding from the left. */
@property (nonatomic, readonly) double left;

/** Padding from the bottom. */
@property (nonatomic, readonly) double bottom;

/** Padding from the right. */
@property (nonatomic, readonly) double right;


- (BOOL)isEqualToEdgeInsets:(nonnull MBMEdgeInsets *)other;

@end
