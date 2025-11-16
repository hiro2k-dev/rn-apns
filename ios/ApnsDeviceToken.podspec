Pod::Spec.new do |s|
  s.name         = "ApnsDeviceToken"
  s.version      = "0.1.0"
  s.summary      = "APNs device token for React Native"
  s.license      = "MIT"
  s.author       = { "You" => "you@example.com" }
  s.homepage     = "https://github.com/you/rn-apns-device-token"
  s.platform     = :ios, "13.0"

  s.source       = { :git => "https://github.com/you/rn-apns-device-token.git", :tag => s.version.to_s }
  s.source_files = "ios/**/*.{h,m,mm,swift}"

  s.swift_version = "5.0"

  s.dependency "React-Core"
end
