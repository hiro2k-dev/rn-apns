import Foundation
import React

@objc(ApnsDeviceEventEmitter)
class ApnsDeviceEventEmitter: RCTEventEmitter {

  static var shared: ApnsDeviceEventEmitter?

  override init() {
    super.init()
    ApnsDeviceEventEmitter.shared = self
  }

  override static func requiresMainQueueSetup() -> Bool {
    return true
  }

  override func supportedEvents() -> [String]! {
    return ["notificationReceived"]
  }
}
    