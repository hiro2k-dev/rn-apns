import { NativeModules } from "react-native";

const { ApnsDeviceToken } = NativeModules;

// Named export
export function getApnsDeviceToken() {
  return ApnsDeviceToken.getDeviceToken();
}

// Optional default export
export default {
  getApnsDeviceToken,
};
