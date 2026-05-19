import Foundation
import PassKit

/// Extension to automatically conform Apple's native `PKSecureElementPass` 
/// to our domain interface `SecureElementPassProvider` for use in the real application.
extension PKSecureElementPass: SecureElementPassProvider {}
