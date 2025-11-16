import { NativeModules } from "react-native";

const { ApnsDeviceToken } = NativeModules;

export function getApnsDeviceToken() {
  console.log("NativeModules.ApnsDeviceToken =", ApnsDeviceToken);
  return ApnsDeviceToken.getDeviceToken();
}

export default { getApnsDeviceToken };
