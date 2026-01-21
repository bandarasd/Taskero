// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBXGeofencingError;
@class MBXGeofencingEvent;

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Geofencing observer for monitoring entry/dwell/exit from features as well as errors.
 */
NS_SWIFT_NAME(__GeofencingObserver)
@protocol MBXGeofencingObserver
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * User enters a monitored feature.
 */
- (void)onEntryForEvent:(nonnull MBXGeofencingEvent *)event
__attribute__((swift_name("onEntry(event:)")));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * User dwells a monitored feature.
 */
- (void)onDwellForEvent:(nonnull MBXGeofencingEvent *)event
__attribute__((swift_name("onDwell(event:)")));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * User exits a monitored feature.
 */
- (void)onExitForEvent:(nonnull MBXGeofencingEvent *)event
__attribute__((swift_name("onExit(event:)")));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Called when an error occurs.
 */
- (void)onErrorForError:(nonnull MBXGeofencingError *)error
__attribute__((swift_name("onError(error:)")));
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Called when the end user consent for Geonfencing changes.
 * True if the user consents Geonfencing features.
 */
- (void)onUserConsentChangedForIsConsentGiven:(BOOL)isConsentGiven
__attribute__((swift_name("onUserConsentChanged(isConsentGiven:)")));
@end
