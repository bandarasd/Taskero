// This file is generated and will be overwritten automatically.

#import <MapboxCommon/MBXSettingsService.h>
#import <MapboxCommon/MBXOnValueChanged_Internal.h>

@interface MBXSettingsService ()
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Set value for the specified key. If there is already value available for specified key then value will be
 * updated. If existing value is the same a new value then no observer callback will be emitted.
 *
 * @param key Key.
 * @param value Value to be set.
 * @return Nothing on success, otherwise a string describing an error.
 */
- (nonnull MBXExpected<NSNull *, NSString *> *)setForKey:(nonnull NSString *)key
                                                   value:(nonnull id)value __attribute((ns_returns_retained));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Set multiple settings from a JSON file.
 * JSON file format:
 * {
 *   "com.mapbox.common.i18n.language": “en-US”,
 *   "com.mapbox.common.boolean": true,
 *   "com.mapbox.common.integer.setting": 100
 * }
 *
 * @param filePath Path to a JSON file.
 * @return Nothing on success, otherwise a string describing an error.
 */
- (nonnull MBXExpected<NSNull *, NSString *> *)setFromFileForFilePath:(nonnull NSString *)filePath __attribute((ns_returns_retained));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Get value for the specified key.
 *
 * @param key Key.
 * @return Value that is stored in the settings, otherwise a string describing an error.
 */
- (nonnull MBXExpected<id, NSString *> *)getForKey:(nonnull NSString *)key __attribute((ns_returns_retained));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Get value for the specified key, if key doesn't exist return a default value.
 *
 * @param key Key.
 * @param defaultValue Value that will be returned in case if there is no associated value exists for provided key.
 * @return Value that is stored in the settings or default value provided as parameter.
 */
- (nonnull MBXExpected<id, NSString *> *)getForKey:(nonnull NSString *)key
                                      defaultValue:(nonnull id)defaultValue __attribute((ns_returns_retained));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Erase value for the specified key. If provided key is not found then this API call does nothing.
 *
 * @param key Key.
 * @return Nothing on success, otherwise a string describing an error.
 */
- (nonnull MBXExpected<NSNull *, NSString *> *)eraseForKey:(nonnull NSString *)key __attribute((ns_returns_retained));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Check if provided key exists in the storage.
 *
 * @param key Key.
 * @return True if key exists in the storage, false if it doesn't exist, or a string describing an error.
 */
- (nonnull MBXExpected<NSNumber *, NSString *> *)hasForKey:(nonnull NSString *)key __attribute((ns_returns_retained));
- (int32_t)registerObserverForKey:(nonnull NSString *)key
                         observer:(nonnull MBXOnValueChanged)observer;
- (int32_t)registerObserverAtSettingsThreadForKey:(nonnull NSString *)key
                                         observer:(nonnull MBXOnValueChanged)observer;
- (void)unregisterObserverForObserverId:(int32_t)observerId;
@end
