// This file is generated and will be overwritten automatically.

#import <MapboxCommon/MBXTileStore.h>
#import <MapboxCommon/MBXAmbientCacheClearingCallback_Internal.h>
#import <MapboxCommon/MBXResourceLoadProgressCallback_Internal.h>
#import <MapboxCommon/MBXResourceLoadResultCallback_Internal.h>
#import <MapboxCommon/MBXTileRegionBooleanCallback_Internal.h>
#import <MapboxCommon/MBXTileRegionCallback_Internal.h>
#import <MapboxCommon/MBXTileRegionEstimateResultCallback_Internal.h>
#import <MapboxCommon/MBXTileRegionGeometryCallback_Internal.h>
#import <MapboxCommon/MBXTileRegionMetadataCallback_Internal.h>
#import <MapboxCommon/MBXTileRegionTilesetsCallback_Internal.h>
#import <MapboxCommon/MBXTileRegionsCallback_Internal.h>
#import <MapboxCommon/MBXTileStoreImportCompleteCallback_Internal.h>

@interface MBXTileStore ()
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Adds a new observer to the TileStore instance.
 *
 * Note that observers will be notified of changes until they're explicitly removed again.
 *
 * @param observer The observer to be added.
 */
- (void)addObserverForObserver:(nonnull id<MBXTileStoreObserver>)observer NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Removes an existing observer from the TileStore instance.
 *
 * If the observer isn't attached to the TileStore anymore, this is a no-op.
 *
 * @param observer The observer to be removed.
 */
- (void)removeObserverForObserver:(nonnull id<MBXTileStoreObserver>)observer NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Loads a new tile region or updates the existing one.
 *
 * Creating of a new region requires providing both geometry and tileset
 * descriptors to the given load options, otherwise the load request fails
 * with RegionNotFound error.
 *
 * If a tile region with the given id already exists, it gets updated with
 * the values provided to the given load options. The missing resources get
 * loaded and the expired resources get updated.
 *
 * If there no values provided to the given load options, the existing tile region
 * gets refreshed: the missing resources get loaded and the expired resources get updated.
 *
 * A failed load request can be reattempted with another loadTileRegion() call.
 *
 * If there is already a pending loading operation for the tile region with the given id
 * the pending loading operation will fail with an error of Canceled type.
 *
 * Note: The user-provided callbacks will be executed on a TileStore-controlled worker thread;
 * it is the responsibility of the user to dispatch to a user-controlled thread.
 *
 * @param id The tile region identifier.
 * @param loadOptions The tile region load options.
 * @param onProgress Invoked multiple times to report progess of the loading operation.
 * @param onFinished Invoked only once upon success, failure, or cancelation of the loading operation.
 * @return Returns a Cancelable object to cancel the load request
 */
- (nonnull id<MBXCancelable>)loadTileRegionForId:(nonnull NSString *)id_
                                     loadOptions:(nonnull MBXTileRegionLoadOptions *)loadOptions
                                      onProgress:(nonnull MBXTileRegionLoadProgressCallback)onProgress
                                      onFinished:(nonnull MBXTileRegionCallback)onFinished __attribute((ns_returns_retained)) NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * An overloaded version that does not report progess of the loading operation.
 *
 * @param id The tile region identifier.
 * @param loadOptions The tile region load options.
 * @param onFinished Invoked only once upon success, failure, or cancelation of the loading operation.
 * @return Returns a Cancelable object to cancel the load request
 */
- (nonnull id<MBXCancelable>)loadTileRegionForId:(nonnull NSString *)id_
                                     loadOptions:(nonnull MBXTileRegionLoadOptions *)loadOptions
                                      onFinished:(nonnull MBXTileRegionCallback)onFinished __attribute((ns_returns_retained)) NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Download incremental updates for a tile region.
 *
 * This method can be used as the first step when updating a tile region. It will download incremental updates for
 * the tiles in the region, using the new tileset descriptors provided in the load options. Note that new geometry
 * or metadata shouldn't be specified and will be ignored. Once the operation completes successfully, the updates
 * can be applied by invoking the applyTileRegionUpdate() method.
 *
 * @param id The tile region to be updated.
 * @param loadOptions Specify what data to update and other options. Geometry is ignored and the existing geometry
 *                    of the tile region is used determine which tiles need update. Metadata is ignored.
 * @param onProgress Invoked multiple times to report progess of the operation.
 * @param onFinished Invoked only once upon success, failure, or cancelation of the operation.
 */
- (nonnull id<MBXCancelable>)prepareTileRegionUpdateForId:(nonnull NSString *)id_
                                              loadOptions:(nonnull MBXTileRegionLoadOptions *)loadOptions
                                               onProgress:(nonnull MBXTileRegionLoadProgressCallback)onProgress
                                               onFinished:(nonnull MBXTileRegionCallback)onFinished __attribute((ns_returns_retained)) NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Updates a tile region using the result of previous call to prepareTileRegionUpdate.
 *
 * This method will apply the previously downloaded incremental updates to the tile region, mutating the existing
 * tile region to contain the tiles specified during the preparation step.
 *
 * @param id The tile region to be updated.
 * @param onProgress Invoked multiple times to report progess of the operation.
 * @param onFinished Invoked only once upon success, failure, or cancelation of the operation.
 */
- (nonnull id<MBXCancelable>)applyTileRegionUpdateForId:(nonnull NSString *)id_
                                                options:(nonnull MBXTileRegionApplyUpdateOptions *)options
                                             onProgress:(nonnull MBXTileRegionLoadProgressCallback)onProgress
                                             onFinished:(nonnull MBXTileRegionCallback)onFinished __attribute((ns_returns_retained)) NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Removes a previously prepared update for a tile region.
 */
- (void)removeTileRegionUpdateForId:(nonnull NSString *)id_
                           callback:(nonnull MBXTileRegionCallback)callback NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Estimates the storage and transfer size of a tile region.
 *
 * This can be used for estimating existing or new tile regions. For new tile
 * regions, both geometry and tileset descriptors need to be provided to the
 * given load options.  If a tile region with the given id already exists, its
 * geometry and tileset descriptors are reused unless a different value is
 * provided in the region load options.
 *
 * Estimating a tile region does not mutate exising tile regions on the tile store.
 *
 * Note: The user-provided callbacks will be executed on a TileStore-controlled worker thread;
 * it is the responsibility of the user to dispatch to a user-controlled thread.
 *
 * @param id The tile region identifier.
 * @param loadOptions The tile region load options.
 * @param estimateOptions The options for the estimate operation.
 * @param onProgress Invoked multiple times to report progess of the estimate operation.
 * @param onFinished Invoked only once upon success, failure, or cancelation of the estimate operation.
 * @return Returns a Cancelable object to cancel the estimate request
 */
- (nonnull id<MBXCancelable>)estimateTileRegionForId:(nonnull NSString *)id_
                                         loadOptions:(nonnull MBXTileRegionLoadOptions *)loadOptions
                                     estimateOptions:(nonnull MBXTileRegionEstimateOptions *)estimateOptions
                                          onProgress:(nonnull MBXTileRegionEstimateProgressCallback)onProgress
                                          onFinished:(nonnull MBXTileRegionEstimateResultCallback)onFinished __attribute((ns_returns_retained)) NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * An overloaded version that uses default options.
 *
 * @param id The tile region identifier.
 * @param options The tile region load options.
 * @param onProgress Invoked multiple times to report progess of the estimate operation.
 * @param onFinished Invoked only once upon success, failure, or cancelation of the estimate operation.
 * @return Returns a Cancelable object to cancel the estimate request
 */
- (nonnull id<MBXCancelable>)estimateTileRegionForId:(nonnull NSString *)id_
                                             options:(nonnull MBXTileRegionLoadOptions *)options
                                          onProgress:(nonnull MBXTileRegionEstimateProgressCallback)onProgress
                                          onFinished:(nonnull MBXTileRegionEstimateResultCallback)onFinished __attribute((ns_returns_retained)) NS_REFINED_FOR_SWIFT;
- (nonnull id<MBXCancelable>)loadResourceForDescription:(nonnull MBXResourceDescription *)description
                                                options:(nonnull MBXResourceLoadOptions *)options
                                       progressCallback:(nonnull MBXResourceLoadProgressCallback)progressCallback
                                         resultCallback:(nonnull MBXResourceLoadResultCallback)resultCallback __attribute((ns_returns_retained));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Checks if a tile region with the given id contains all tilesets and resources from all of the given tileset descriptors.
 *
 * Note: The user-provided callbacks will be executed on a TileStore-controlled worker thread;
 * it is the responsibility of the user to dispatch to a user-controlled thread.
 *
 * @param id The tile region identifier.
 * @param descriptors The list of tileset descriptors.
 * @param callback The result callback.
 */
- (void)tileRegionContainsDescriptorsForId:(nonnull NSString *)id_
                               descriptors:(nonnull NSArray<MBXTilesetDescriptor *> *)descriptors
                                  callback:(nonnull MBXTileRegionBooleanCallback)callback NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Returns a list of the existing tile regions.
 *
 * Note: The user-provided callbacks will be executed on a TileStore-controlled worker thread;
 * it is the responsibility of the user to dispatch to a user-controlled thread.
 *
 * @param callback The result callback.
 */
- (void)getAllTileRegionsForCallback:(nonnull MBXTileRegionsCallback)callback NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Returns a tile region by its id.
 *
 * Note: The user-provided callbacks will be executed on a TileStore-controlled worker thread;
 * it is the responsibility of the user to dispatch to a user-controlled thread.
 *
 * @param id The tile region id.
 * @param callback The result callback.
 */
- (void)getTileRegionForId:(nonnull NSString *)id_
                  callback:(nonnull MBXTileRegionCallback)callback NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Returns a tile region's associated geometry
 *
 * The region associated geometry is provided by the client and it represents the area, which the tile
 * region must cover. The actual regional geometry depends on the tiling scheme and might exceed the
 * associated geometry.
 *
 * Note: The user-provided callbacks will be executed on a TileStore-controlled worker thread;
 * it is the responsibility of the user to dispatch to a user-controlled thread.
 *
 * @param id The tile region id.
 * @param callback The result callback.
 */
- (void)getTileRegionGeometryForId:(nonnull NSString *)id_
                          callback:(nonnull MBXTileRegionGeometryCallback)callback NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Returns a tile region's associated metadata
 *
 * The region's associated metadata that a user previously set for this region.
 *
 * @param id The tile region id.
 * @param callback The result callback.
 */
- (void)getTileRegionMetadataForId:(nonnull NSString *)id_
                          callback:(nonnull MBXTileRegionMetadataCallback)callback NS_REFINED_FOR_SWIFT;
- (void)getTileRegionTilesetsForId:(nonnull NSString *)id_
                          callback:(nonnull MBXTileRegionTilesetsCallback)callback NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * An overloaded version with a callback for feedback.
 * On successful tile region removal, the given callback is invoked with the removed tile region. Otherwise, the given callback is invoked with an error.
 * When a tile region is removed associated resources will move to the ambient cache.
 *
 * @param id The tile region identifier.
 * @param callback A callback to be invoked when a tile region was removed.
 */
- (void)removeTileRegionForId:(nonnull NSString *)id_
                     callback:(nonnull MBXTileRegionCallback)callback NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * @brief Computes a polygon of the area covered by the tiles cached in TileStore with the specified TilesetDescriptors.
 * @param descriptors The list of tileset descriptors.
 * @param callback A callback that will be invoked with the resulting polygon.
 */
- (void)computeCoveredAreaForDescriptors:(nonnull NSArray<MBXTilesetDescriptor *> *)descriptors
                                callback:(nonnull MBXTileRegionGeometryCallback)callback;
- (void)clearAmbientCacheForCallback:(nonnull MBXAmbientCacheClearingCallback)callback
                       filterOptions:(nonnull MBXTileStoreAmbientCacheFilterOptions *)filterOptions;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Clears the ambient cache data
 *
 * Equivalent to the other clearAmbientCache() overload with the filters set to include all ambient cache
 */
- (void)clearAmbientCacheForCallback:(nonnull MBXAmbientCacheClearingCallback)callback;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Import an archive to the tile store.
 *
 * Imports an offline data archive from an external location. When invoked, import will first compare the contents
 * of the TileStore against the archive to determine which resources need to be updated or created. Resources that
 * don't exist in the TileStore or that are older than the version in the archive will be updated accordingly.
 *
 * The update will happen in small batches to prevent TileStore from becoming unresponsive. During the update,
 * TileStore should still be able to serve resources that are not part of the current batch normally. Import is
 * resumed even if it is interrupted unexpectedly.
 *
 * Import will by default also import the regions it contains. When a region with the same name already exists in
 * the TileStore, that region will be changed to match the archive, including its geometry, tileset descriptors and
 * metadata.
 *
 * This process can be customized by using TileStoreImportOptions.
 *
 * @param options Specifies the location and data to import, along with additional import options.
 * @param onProgress Invoked multiple times to report progress of the operation.
 * @param onFinished Invoked only once upon success, failure, or cancellation of the operation.
 *
 * @return Returns a Cancelable object to cancel the import request
 */
- (nonnull id<MBXCancelable>)importArchiveForOptions:(nonnull MBXTileStoreImportOptions *)options
                                          onProgress:(nonnull MBXTileStoreImportProgressCallback)onProgress
                                          onFinished:(nonnull MBXTileStoreImportCompleteCallback)onFinished __attribute((ns_returns_retained)) NS_REFINED_FOR_SWIFT;
@end
