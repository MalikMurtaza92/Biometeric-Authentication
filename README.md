# Biometeric Manager
BiometricsManager provides a streamlined way to handle biometric authentication (Face ID/Touch ID) with a passcode fallback, handling common errors and edge cases (e.g., cancellation, fallback to passcode) so you don’t have to manually manage them.

### Features
- Simple interface for biometric authentication with Face ID or Touch ID.
- Automatic fallback to passcode if biometric authentication fails.
- Detailed error handling for common issues such as user cancellation, lack of biometric enrollment, or unavailable biometrics.

### Installation
#### 1. Clone or download the repository
To get started, simply download or clone this repository.
```https://github.com/MalikMurtaza92/Biometeric-Authentication.git ```

#### 2. Drag and drop
Manually drag the BiometricsManager.swift file into your Xcode project.

1. Open your Xcode project.
2. In the Finder, locate the BiometricsManager.swift file.
3. Drag and drop the file into your project’s file navigator.

### Usage
Here’s a quick example of how to use BiometricsManager to authenticate the user:
```swift
BiometricsManager.shared.authenticateUser(reason: "Log in to your account") { result in
    switch result {
    case .success(let success):
        print("Authentication successful: \(success)")
    case .failure(let error):
        print("Authentication failed: \(error.localizedDescription)")
    }
}
```
#### Customization
You can customize the cancel and fallback titles used during authentication:
```swift
BiometricsManager.shared.cancelTitle = "Cancel"
BiometricsManager.shared.fallbackTitle = "Use Passcode"
```

#### Handling Errors
BiometricsError enum provides detailed information about the errors encountered during biometric authentication:
```swift
switch error {
case .notAvailable:
    print("Biometrics not available on this device.")
case .notEnrolled:
    print("No biometric credentials are enrolled.")
case .userCancelled:
    print("User canceled the authentication.")
default:
    print("Unknown error: \(error.localizedDescription)")
}
```

#### Info.plist Configuration
To use Face ID or Touch ID, ensure you’ve added the required usage descriptions to your Info.plist:
```swift
<key>NSFaceIDUsageDescription</key>
<string>We need to use Face ID to authenticate you</string>
```
### License
This project is available under the MIT license. See the LICENSE file for more information.
