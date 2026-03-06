// This file is generated and will be overwritten automatically.

#import <MapboxCommon/MBXHttpResponse.h>

@interface MBXHttpResponse ()
- (nonnull instancetype)initWithRequestId:(uint64_t)requestId
                                  request:(nonnull MBXHttpRequest *)request
                                   result:(nonnull MBXExpected<MBXHttpResponseData *, MBXHttpRequestError *> *)result NS_REFINED_FOR_SWIFT;
/**
 * WARNING: This API is not intended for public usage. It can be deleted or changed without any notice.
 * Result of HTTP request call.
 */
@property (nonatomic, readonly, nonnull) MBXExpected<MBXHttpResponseData *, MBXHttpRequestError *> *result NS_REFINED_FOR_SWIFT;

@end
