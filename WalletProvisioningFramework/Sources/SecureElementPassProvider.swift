import Foundation
import PassKit

/// An abstraction for `PKSecureElementPass` that allows testing of the Apple Pay Extension
/// without needing access to actual pass hardware or entitlements.
public protocol SecureElementPassProvider {
    /// The last four digits of the physical or virtual payment card.
    var primaryAccountNumberSuffix: String { get }
    
    /// The current lifecycle state of the pass (e.g., activated, deactivated).
    var passActivationState: PKSecureElementPass.PassActivationState { get }
    
    /// A unique identifier for the primary account associated with the pass.
    var primaryAccountIdentifier: String { get }
}
