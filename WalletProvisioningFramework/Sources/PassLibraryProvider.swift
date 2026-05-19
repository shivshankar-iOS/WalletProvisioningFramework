import Foundation
import PassKit

/// An abstraction for `PKPassLibrary` allowing unit testing of Apple Pay provisioning status logic.
public protocol PassLibraryProvider {
    /// Fetches all passes of the specified type that are currently on the device.
    /// - Parameter passType: The type of pass to retrieve (e.g., .secureElement).
    /// - Returns: An array of abstracted `SecureElementPassProvider` instances.
    func fetchPasses(of passType: PKPassType) -> [SecureElementPassProvider]
    
    /// Checks whether a specific secure element pass can be added to an associated Apple Watch.
    /// - Parameter primaryAccountIdentifier: The identifier for the account checking for Watch provisioning.
    /// - Returns: A boolean indicating if the pass can be added to the connected Watch.
    func canAddSecureElementPass(primaryAccountIdentifier: String) -> Bool
}
