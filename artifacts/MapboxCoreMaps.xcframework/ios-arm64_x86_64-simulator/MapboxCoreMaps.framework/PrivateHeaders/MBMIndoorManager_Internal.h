// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxCoreMaps/MBMIndoorUpdatedCallback_Internal.h>

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Interface for managing indoor features.
 * EXPERIMENTAL: Not intended for usage in current stata. Subject to change or deletion.
 */
NS_SWIFT_NAME(__IndoorManager)
__attribute__((visibility ("default")))
@interface MBMIndoorManager : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Selects an indoor floor for rendering.
 * When a floor is selected, the map will render features associated with that floor and connected floors.
 * EXPERIMENTAL: Not intended for usage in current stata. Subject to change or deletion.
 *
 * @param selectedFloorId The ID of the floor to select.
 */
- (void)selectFloorForSelectedFloorId:(nonnull NSString *)selectedFloorId
__attribute__((swift_name("selectFloor(selectedFloorId:)")));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Sets a callback to be invoked when indoor state updates.
 * State is updated either when a new floor is selected through API or user moved the camera to focus on another building.
 * EXPERIMENTAL: Not intended for usage in current stata. Subject to change or deletion.
 *
 * @param onIndoorUpdate The callback to be invoked with indoor state updates.
 */
- (void)onIndoorUpdateForOnIndoorUpdate:(nonnull MBMIndoorUpdatedCallback)onIndoorUpdate
__attribute__((swift_name("onIndoorUpdate(onIndoorUpdate:)")));

@end
