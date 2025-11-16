require 'json'

package = JSON.parse(File.read(File.join(__dir__, '..', 'package.json')))

Pod::Spec.new do |s|
  s.name         = "ApnsDeviceToken"
  s.version      = package["version"]
  s.summary      = package["description"] || "APNs device token for React Native"
  s.homepage     = "https://github.com/hiro2k-dev/rn-apns"
  s.license      = { :type => "MIT", :text => "MIT" }
  s.author       = { "hiro2k" => "you@example.com" }

  s.platform     = :ios, "13.0"

  s.source       = { :path => "." }

  s.source_files = "ApnsDeviceToken.swift"

  s.dependency   "React-Core"
  s.swift_version = "5.0"
end
