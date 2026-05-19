import Foundation
import PassKit

/// A service provider that computes the availability status of payment cards
/// for Apple Pay provisioning on both the current iOS device and any paired Apple Watch.
///
/// This class conforms to the exact logic required to support a `PKIssuerProvisioningExtensionHandler`.
public class ProvisioningStatusProvider {
    
    private let passLibrary: PassLibraryProvider
    private let lastDigitsList: [String]
    
    public init(lastDigitsList: [String], passLibrary: PassLibraryProvider = PKPassLibrary()) {
        self.lastDigitsList = lastDigitsList
        self.passLibrary = passLibrary
    }
    
    public func status(completion: @escaping (PKIssuerProvisioningExtensionStatus) -> Void) {
        let status = PKIssuerProvisioningExtensionStatus()
        status.requiresAuthentication = true
        status.passEntriesAvailable = false
        status.remotePassEntriesAvailable = false
        
        let secureElementPasses = passLibrary.fetchPasses(of: .secureElement)
        
        for lastDigits in lastDigitsList {
            let matchingPasses = secureElementPasses.filter { $0.primaryAccountNumberSuffix == lastDigits }
            
            if matchingPasses.isEmpty {
                // If no match is found for the given lastDigits, the card is not present on the current device,
                // so it is possible to add it.
                status.passEntriesAvailable = true
            } else {
                // Match is found. Check if any are active.
                if let activePass = matchingPasses.first(where: { $0.passActivationState != .deactivated }) {
                    // Card is considered present on the current device.
                    // Next, check if it can still be provisioned on a connected Apple Watch.
                    if passLibrary.canAddSecureElementPass(primaryAccountIdentifier: activePass.primaryAccountIdentifier) {
                        status.remotePassEntriesAvailable = true
                    }
                } else {
                    // All matching passes are deactivated. Treat as not present on the device.
                    status.passEntriesAvailable = true
                }
            }
        }
        
        completion(status)
    }
}




