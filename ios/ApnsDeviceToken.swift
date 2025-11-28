//  ApnsDeviceToken.swift
import Foundation
import UIKit
import UserNotifications
import React

@objc(ApnsDeviceToken)
public class ApnsDeviceToken: NSObject, UNUserNotificationCenterDelegate {

  @objc
  public static func requiresMainQueueSetup() -> Bool {
    return true
  }

  public static var shared: ApnsDeviceToken?

  private var pendingResolver: RCTPromiseResolveBlock?
  private var pendingRejecter: RCTPromiseRejectBlock?
  private var cachedToken: String?

  private var initialNotification: [String: Any]?
  private var hasListeners = false

  public override init() {
    super.init()
    ApnsDeviceToken.shared = self

    // Receive notifications in foreground
    UNUserNotificationCenter.current().delegate = self

    // Detect initial notification (when app cold start by tapping notification)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleInitialNotification(_:)),
      name: UIApplication.didFinishLaunchingNotification,
      object: nil
    )
  }

  // MARK: - 1. REQUEST PERMISSIONS
  @objc
  public func requestPermissions(_ resolve: @escaping RCTPromiseResolveBlock,
                                 rejecter reject: @escaping RCTPromiseRejectBlock) {

    UNUserNotificationCenter.current().requestAuthorization(
      options: [.alert, .badge, .sound]
    ) { granted, error in
      DispatchQueue.main.async {
        if let error = error {
          reject("E_PERMISSION", error.localizedDescription, error)
          return
        }
        resolve(granted)
      }
    }
  }

  // MARK: - 2. GET DEVICE TOKEN (APNs)
  @objc
  public func getDeviceToken(_ resolve: @escaping RCTPromiseResolveBlock,
                             rejecter reject: @escaping RCTPromiseRejectBlock) {

    if let token = cachedToken {
      resolve(token)
      return
    }

    pendingResolver = resolve
    pendingRejecter = reject

    UIApplication.shared.registerForRemoteNotifications()
  }

  private func clearPending() {
    pendingResolver = nil
    pendingRejecter = nil
  }

  @objc
  public static func didRegisterForRemoteNotifications(deviceToken: Data) {
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()

    DispatchQueue.main.async {
      guard let shared = ApnsDeviceToken.shared else { return }
      shared.cachedToken = token
      shared.pendingResolver?(token)
      shared.clearPending()
    }
  }

  @objc
  public static func didFailToRegisterForRemoteNotifications(error: Error) {
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

  // MARK: - 3. INITIAL NOTIFICATION
  @objc
  public func getInitialNotification(_ resolve: RCTPromiseResolveBlock,
                                     rejecter reject: RCTPromiseRejectBlock) {
    resolve(initialNotification)
  }

  @objc
  private func handleInitialNotification(_ notification: Notification) {
    if let userInfo = notification.userInfo?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
      initialNotification = userInfo
    }
  }

  // MARK: - 4. EVENT LISTENER (Foreground push)
  @objc
  public func addListener(_ eventName: NSString) {
    hasListeners = true
  }

  @objc
  public func removeListeners(_ count: NSNumber) {
    hasListeners = false
  }

  // Foreground push (app đang mở)
  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {

    let payload = notification.request.content.userInfo

    if hasListeners {
      NotificationCenter.default.post(
        name: NSNotification.Name("ApnsDeviceToken_NotificationReceived"),
        object: nil,
        userInfo: payload
      )
    }

    // show banner + sound + badge
    completionHandler([.alert, .badge, .sound])
  }
}
