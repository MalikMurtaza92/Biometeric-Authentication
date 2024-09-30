//
//  BiometricsManager.swift
//  BiometricAuth
//
//  Created by Murtaza Mehmood on 28/09/2024.
//

import Foundation
import LocalAuthentication

/**
 An enumeration representing possible errors encountered during biometric authentication.

 - notAvailable: Biometric authentication is not available on this device.
 - notEnrolled: No biometric authentication credentials are enrolled on this device.
 - invalidContext: The authentication context is invalid.
 - invalidOperation: The operation is not valid in the current state.
 - userFallback: The user chose to enter the passcode instead of using biometrics.
 - userCancelled: The user cancelled the biometric authentication process.
 - unknown: An unknown error occurred during the authentication process, with an associated error.
 */
enum BiometricsError: Error {
    case notAvailable
    case notEnrolled
    case invalidContext
    case invalidOperation
    case userFallback
    case userCancelled
    case unknown(Error)
}

/**
 Extension of the `BiometricsError` enum that conforms to the `LocalizedError` protocol.
 This provides user-friendly descriptions of the errors encountered during biometric authentication.
 */
extension BiometricsError: LocalizedError {
    
    /// Returns a localized description for each type of biometric error.
    public var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "Biometric authentication is not available on this device."
        case .notEnrolled:
            return "No biometric authentication credentials are enrolled on this device."
        case .invalidContext:
            return "The authentication context is invalid."
        case .invalidOperation:
            return "The operation is not valid in the current state."
        case .userFallback:
            return "The user chose to enter the passcode instead of using biometrics."
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        default:
            return "unknown"
        }
    }
}

/**
 A singleton manager responsible for handling biometric authentication using Apple's LocalAuthentication framework.

 - `shared`: Provides a shared instance of `BiometricsManager`.
 - `type`: The type of biometric authentication available on the device (e.g., Face ID, Touch ID).
 - `cancelTitle`: The localized title for the cancel button during authentication.
 - `fallbackTitle`: The localized title for the fallback button to enter the passcode.
 */
struct BiometricsManager {
    
    /// Shared singleton instance of `BiometricsManager`.
    static let shared = BiometricsManager()
    
    /// The context for biometric authentication, using `LAContext`.
    private let biometricsContext = LAContext()
    
    /// The type of biometric authentication available on this device (e.g., Face ID, Touch ID).
    var type: LABiometryType { biometricsContext.biometryType }
    
    /// Title for the cancel button during the authentication process.
    var cancelTitle: String = "Cancel"
    
    /// Title for the fallback button, allowing the user to enter their passcode.
    var fallbackTitle: String = "Enter passcode"
    
    /// Initializes a new instance of `BiometricsManager`.
    init () {}
    
    /**
     Authenticates the user using biometric authentication or passcode fallback.

     - Parameters:
        - reason: A string describing why the app is requesting authentication (default is "Log in account").
        - completion: A closure that returns a `Result` indicating whether authentication succeeded or failed.
     
     The result in the completion handler will either return `true` if the authentication succeeded, or an appropriate `BiometricsError` if it failed.
     */
    func authenticateUser(reason: String? = nil, completion: @escaping (Result<Bool, BiometricsError>) -> Void) {
                
        var error: NSError?
        
        // Check if biometric authentication can be evaluated on the device
        guard biometricsContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            return DispatchQueue.main.async {
                completion(.failure(.notAvailable))
            }
        }
        
        // Set the localized titles for cancel and fallback options
        biometricsContext.localizedCancelTitle = cancelTitle
        biometricsContext.localizedFallbackTitle = fallbackTitle
        
        // Start the biometric evaluation process
        biometricsContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ?? "Log in account") { success, biometericError in
            if success {
                DispatchQueue.main.async {
                    completion(.success(success))
                }
            } else {
                DispatchQueue.main.async {
                    // Handle various authentication errors
                    if let authError = biometericError as? LAError {
                        switch authError.code {
                        case .biometryNotEnrolled:
                            completion(.failure(.notEnrolled))
                        case .userCancel:
                            completion(.failure(.userCancelled))
                        case .userFallback:
                            completion(.failure(.userFallback))
                        default:
                            completion(.failure(.unknown(biometericError!)))
                        }
                    } else {
                        completion(.failure(.unknown(biometericError!)))
                    }
                }
            }
        }
    }
}
