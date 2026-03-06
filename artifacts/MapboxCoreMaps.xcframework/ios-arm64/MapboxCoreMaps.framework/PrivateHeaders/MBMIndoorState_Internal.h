// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBMIndoorFloor;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Represents the current indoor state, including available floors and the selected floor.
 * EXPERIMENTAL: Not intended for usage in current stata. Subject to change or deletion.
 */
NS_SWIFT_NAME(__IndoorState)
__attribute__((visibility ("default")))
@interface MBMIndoorState : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithFloors:(nonnull NSArray<MBMIndoorFloor *> *)floors
                       selectedFloorId:(nonnull NSString *)selectedFloorId;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * List of all available floors in the current indoor building.
 */
@property (nonatomic, readonly, nonnull, copy) NSArray<MBMIndoorFloor *> *floors;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * The ID of the currently selected floor.
 */
@property (nonatomic, readonly, nonnull, copy) NSString *selectedFloorId;


@end
