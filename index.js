import { NativeModules } from "react-native";

const { ApnsDeviceToken } = NativeModules;

export function getApnsDeviceToken(): Promise<string> {
  return ApnsDeviceToken.getDeviceToken();
}

export default { getApnsDeviceToken };
