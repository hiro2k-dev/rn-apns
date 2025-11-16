import Foundation
import UIKit
import UserNotifications
import React

@objc(ApnsDeviceToken)
class ApnsDeviceToken: NSObject, RCTBridgeModule {

  static func moduleName() -> String! {
    return "ApnsDeviceToken"
  }

  static func requiresMainQueueSetup() -> Bool {
    return true
  }

  static var shared: ApnsDeviceToken?

  private var pendingResolver: RCTPromiseResolveBlock?
  private var pendingRejecter: RCTPromiseRejectBlock?
  private var cachedToken: String?

  override init() {
    super.init()
    ApnsDeviceToken.shared = self
  }

  @objc(getDeviceToken:rejecter:)
  func getDeviceToken(_ resolve: @escaping RCTPromiseResolveBlock,
                      rejecter reject: @escaping RCTPromiseRejectBlock) {

    if let token = cachedToken {
      resolve(token)
      return
    }

    pendingResolver = resolve
    pendingRejecter = reject

    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      DispatchQueue.main.async {
        if let error = error {
          reject("E_PERMISSION", error.localizedDescription, error)
          self.clearPending()
          return
        }

        if !granted {
          reject("E_PERMISSION_DENIED", "Permission denied", nil)
          self.clearPending()
          return
        }

        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }

  private func clearPending() {
    pendingResolver = nil
    pendingRejecter = nil
  }

  @objc
  static func didRegisterForRemoteNotifications(deviceToken: Data) {
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()

    DispatchQueue.main.async {
      guard let shared = ApnsDeviceToken.shared else { return }
      shared.cachedToken = token
      shared.pendingResolver?(token)
      shared.clearPending()
    }
  }

  @objc
  static func didFailToRegisterForRemoteNotifications(error: Error) {
    DispatchQueue.main.async {
      guard let shared = ApnsDeviceToken.shared else { return }
      shared.pendingRejecter?(
        "E_REGISTER",
        error.localizedDescription,
        error
      )
      shared.clearPending()
    }
  }
}
