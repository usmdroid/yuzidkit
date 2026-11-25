Pod::Spec.new do |s|
  s.name             = 'YuzIDKit'
  s.version          = '1.0.0'
  s.summary          = 'YuzID native iOS face liveness detection (Vision + ML Kit).'
  s.homepage         = 'https://github.com/usmdroid/yuzidkit'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'SICNT' => 'info@yt.uz' }
  s.source           = { :git => 'https://github.com/usmdroid/yuzidkit.git', :tag => s.version.to_s }

  s.platform         = :ios, '15.5'
  s.swift_version    = '5.0'
  s.frameworks       = 'UIKit', 'AVFoundation', 'Vision'
  s.vendored_frameworks = 'YuzIDKit.xcframework'
  s.static_framework = true

  # ML Kit is not bundled: CocoaPods installs it as a dependency.
  s.dependency 'MLKitFaceDetection', '~> 8.0.0'
end
