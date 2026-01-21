// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Represents a single floor within an indoor venue.
 * EXPERIMENTAL: Not intended for usage in current stata. Subject to change or deletion.
 */
NS_SWIFT_NAME(__IndoorFloor)
__attribute__((visibility ("default")))
@interface MBMIndoorFloor : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithId:(nonnull NSString *)id_
                              name:(nonnull NSString *)name;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Unique identifier for the floor.
 */
@property (nonatomic, readonly, nonnull, copy) NSString *id;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Display name of the floor (e.g., "1", "L2"). Can be alphanumeric, but no longer than 3 symbols length.
 */
@property (nonatomic, readonly, nonnull, copy) NSString *name;


@end
