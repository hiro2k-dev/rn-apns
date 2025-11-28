// index.js
import { NativeModules, NativeEventEmitter } from "react-native";

const { ApnsDeviceToken, ApnsDeviceEventEmitter } = NativeModules;

// Event emitter for foreground notifications
const emitter = new NativeEventEmitter(ApnsDeviceEventEmitter);

// ---- 1. DEVICE TOKEN ----
export function getApnsDeviceToken() {
  console.log("NativeModules.ApnsDeviceToken =", ApnsDeviceToken);
  return ApnsDeviceToken.getDeviceToken();
}

// ---- 2. REQUEST PERMISSIONS ----
export function requestPermissions() {
  return ApnsDeviceToken.requestPermissions();
}

// ---- 3. INITIAL NOTIFICATION ----
export function getInitialNotification() {
  return ApnsDeviceToken.getInitialNotification();
}

// ---- 4. FOREGROUND NOTIFICATION LISTENER ----
export function addNotificationListener(handler) {
  return emitter.addListener("notificationReceived", handler);
}

export function removeNotificationListener(subscription) {
  if (subscription?.remove) {
    subscription.remove();
  }
}

// default export (optional)
export default {
  getApnsDeviceToken,
  requestPermissions,
  getInitialNotification,
  addNotificationListener,
  removeNotificationListener,
};
