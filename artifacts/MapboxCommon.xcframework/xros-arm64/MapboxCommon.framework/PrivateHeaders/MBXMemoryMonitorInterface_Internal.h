// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxCommon/MBXMemoryMonitorStatusCallback_Internal.h>

@class MBXMemoryMonitorObserverConfig;
@protocol MBXMemoryMonitorObserver;

NS_SWIFT_NAME(MemoryMonitorInterface)
@protocol MBXMemoryMonitorInterface
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Get the current memory status.
 *
 * @param config A config to detect the proper state
 * @param callback A callback to get the status.
 */
- (void)getMemoryMonitorStatusForConfig:(nonnull MBXMemoryMonitorObserverConfig *)config
                               callback:(nonnull MBXMemoryMonitorStatusCallback)callback;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Registers a memory status observer with a default config, automatically starts
 * monitoring if it has not been started yet.
 * Its configuration can be changed at any time with non persistent settings:
 * com.mapbox.common.memory_monitor.default.max_used_memory_percent_threshold (in percents)
 * com.mapbox.common.memory_monitor.default.max_used_memory_threshold (in bytes)
 * com.mapbox.common.memory_monitor.default.notification_timeout (in milliseconds)
 *
 * You should always add an observer with default config to give customers possibility to control
 * memory monitor settings for their app.
 *
 * @param observer An observer to register.
 */
- (void)registerObserverForObserver:(nonnull id<MBXMemoryMonitorObserver>)observer;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Registers a memory status observer with a config, automatically starts
 * monitoring if it has not been started yet.
 *
 * Note: Observer functions will be executed in MemoryMonitor thread
 *
 * @param config Configuration for memory monitor to define when to trigger observer notifications
 * @param observer An observer to register.
 */
- (void)registerObserverWithConfigForConfig:(nonnull MBXMemoryMonitorObserverConfig *)config
                                   observer:(nonnull id<MBXMemoryMonitorObserver>)observer;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Unregister a memory status observer. Once the last observer
 * is unregistered it stops monitoring.
 *
 * @param observer An observer to unregister.
 */
- (void)unregisterObserverForObserver:(nonnull id<MBXMemoryMonitorObserver>)observer;
/**
 * Notify all observers about SystemMemoryWarningReceived message
 *
 * When application uses own ways of monitoring high memory usage, it can
 * call this function to send all the observers a message with the state
 * SystemMemoryWarningReceived to force them to free the memory
 */
- (void)notifySystemMemoryWarningReceived;
@end
