// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Use the following keys in the properties of your GeoJSON Feature to configure geofencing engine per Feature.
 * For example:
 * {
 *  "geometry":{"coordinates":[11.7846331,48.3527223],"type":"Point"},
 *  "properties":{"MBX_GEOFENCE_DWELL_TIME":10, "MBX_GEOFENCE_POINT_RADIUS":100},
 *  "type":"Feature"
 * }
 */
NS_SWIFT_NAME(__GeofencingPropertiesKeys)
__attribute__((visibility ("default")))
@interface MBXGeofencingPropertiesKeys : NSObject

    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * Key value for setting dwell time (in minutes) in Feature properties. The dwell time must be positive and bigger than 1 minute.
     * ```
     * {
     *  "geometry":{...},
     *  "properties":{
     *  "MBX_GEOFENCE_DWELL_TIME":10
     *  },
     *  "type":"Feature"
     * }
     * ```
     */
    @property (nonatomic, class, readonly) NSString * DwellTimeKey;
    /**
     * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
     * Key value for setting the monitoring radius (in meters) in Feature properties for a point geometry. The value is rounded to full meters.
     * ```
     * {
     *  "geometry":{"coordinates":[...],"type":"Point"},
     *  "properties":{
     *  "MBX_GEOFENCE_POINT_RADIUS":100
     *  },
     *  "type":"Feature"
     * }
     * ```
     */
    @property (nonatomic, class, readonly) NSString * PointRadiusKey;

@end
