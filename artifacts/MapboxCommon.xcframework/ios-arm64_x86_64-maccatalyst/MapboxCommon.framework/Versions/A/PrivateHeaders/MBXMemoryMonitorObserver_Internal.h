// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBXMemoryMonitorStatus;

NS_SWIFT_NAME(MemoryMonitorObserver)
@protocol MBXMemoryMonitorObserver
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Called when memory alert is sent by Mapbox.
 * @param status: Current status
 */
- (void)onMemoryMonitorAlertForStatus:(nonnull MBXMemoryMonitorStatus *)status;
@end
