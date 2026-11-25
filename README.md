# YuzIDKit (iOS)

Prebuilt XCFramework for on-device face capture: the user is guided to position their face (distance, head angle, open eyes, no smile), a 3-2-1 countdown runs, and a sharp `UIImage` is returned. Built on Vision and Google ML Kit.

## Requirements
- iOS 15.5+, Swift 5
- `NSCameraUsageDescription` in `Info.plist`
- A real device: ML Kit has no arm64 simulator slice, and this XCFramework ships the `ios-arm64` slice only

## Installation (CocoaPods)
```ruby
platform :ios, '15.5'
use_frameworks! :linkage => :static   # required by ML Kit

pod 'YuzIDKit', :git => 'https://github.com/usmdroid/yuzidkit.git', :tag => '1.0.0'
```
ML Kit is pulled in automatically; do not add it yourself.

## Usage
```swift
import YuzIDKit

YuzID.present(language: .uz) { result in
    switch result {
    case .success(let image): // UIImage; result.base64JPEG is also available
    case .cancelled:          // user tapped Back
    case .failure(let error): // .alreadyRunning, .noViewController, .cameraUnavailable
    }
}
```
Languages: `.uz`, `.uzCyrillic`, `.ru`, `.en`. Legacy codes are supported via `YuzIDLanguage(code: "eng")`.

Optional: an image named `large_logo` in the app bundle is shown under the camera circle.

## Example app
```bash
cd example && pod install && open Example.xcworkspace
```
Pick your signing team and run on a real iPhone.

## License
Apache-2.0
