#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(ApnsDeviceToken, NSObject)

RCT_EXTERN_METHOD(
  getDeviceToken:(RCTPromiseResolveBlock)resolve
  rejecter:(RCTPromiseRejectBlock)reject
)

@end
