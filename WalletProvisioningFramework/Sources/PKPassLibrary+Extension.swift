import Foundation
import PassKit

/// Extension to map Apple's native `PKPassLibrary` to our `PassLibraryProvider` domain interface,
/// allowing the real app extension to use the actual iOS PassLibrary logic under the hood.
extension PKPassLibrary: PassLibraryProvider {
    public func fetchPasses(of passType: PKPassType) -> [SecureElementPassProvider] {
        return self.passes(of: passType).compactMap { $0 as? PKSecureElementPass }
    }
}
