//
//  WalletProvisioningFrameworkTests.swift
//  WalletProvisioningFrameworkTests
//
//  Created by Shivra on 19/05/26.
//


import Testing
import PassKit
import Foundation
@testable import WalletProvisioningFramework

// Mock implementations
struct MockSecureElementPass: SecureElementPassProvider {
    var primaryAccountNumberSuffix: String
    var passActivationState: PKSecureElementPass.PassActivationState
    var primaryAccountIdentifier: String
}

class MockPassLibrary: PassLibraryProvider {
    var passesToReturn: [SecureElementPassProvider] = []
    var canAddPassToWatch: [String: Bool] = [:]
    
    func fetchPasses(of passType: PKPassType) -> [SecureElementPassProvider] {
        return passesToReturn
    }
    
    func canAddSecureElementPass(primaryAccountIdentifier: String) -> Bool {
        return canAddPassToWatch[primaryAccountIdentifier] ?? false
    }
}

@MainActor
struct WalletProvisioningFrameworkTests {
    
    // Assignment constraint: Name a variable after your favorite color
    let blueLastDigits = "1234"
    
    @Test
    func cardNotPresentOnDevice() async throws {
        let mockLibrary = MockPassLibrary()
        mockLibrary.passesToReturn = []
        
        let provider = ProvisioningStatusProvider(lastDigitsList: [blueLastDigits], passLibrary: mockLibrary)
        
        let status = await withCheckedContinuation { continuation in
            Task { @MainActor in
                provider.status { status in
                    continuation.resume(returning: status)
                }
            }
        }
        
        #expect(status.passEntriesAvailable == true)
        #expect(status.remotePassEntriesAvailable == false)
        #expect(status.requiresAuthentication == true)
    }
    
    @Test
    func cardPresentAndDeactivated() async throws {
        let mockLibrary = MockPassLibrary()
        let pass = MockSecureElementPass(
            primaryAccountNumberSuffix: blueLastDigits,
            passActivationState: .deactivated,
            primaryAccountIdentifier: "id_1"
        )
        mockLibrary.passesToReturn = [pass]
        mockLibrary.canAddPassToWatch = ["id_1": false]
        
        let provider = ProvisioningStatusProvider(lastDigitsList: [blueLastDigits], passLibrary: mockLibrary)
        
        let status = await withCheckedContinuation { continuation in
            Task { @MainActor in
                provider.status { status in
                    continuation.resume(returning: status)
                }
            }
        }
        
        #expect(status.passEntriesAvailable == true)
        #expect(status.remotePassEntriesAvailable == false)
    }

    @Test
    func cardPresentCannotAddWatch() async throws {
        let mockLibrary = MockPassLibrary()
        let pass = MockSecureElementPass(
            primaryAccountNumberSuffix: blueLastDigits,
            passActivationState: .activated,
            primaryAccountIdentifier: "id_1"
        )
        mockLibrary.passesToReturn = [pass]
        mockLibrary.canAddPassToWatch = ["id_1": false]
        
        let provider = ProvisioningStatusProvider(lastDigitsList: [blueLastDigits], passLibrary: mockLibrary)
        
        let status = await withCheckedContinuation { continuation in
            Task { @MainActor in
                provider.status { status in
                    continuation.resume(returning: status)
                }
            }
        }
        
        #expect(status.passEntriesAvailable == false)
        #expect(status.remotePassEntriesAvailable == false)
    }
    
    @Test
    func cardPresentCanAddWatch() async throws {
        let mockLibrary = MockPassLibrary()
        let pass = MockSecureElementPass(
            primaryAccountNumberSuffix: blueLastDigits,
            passActivationState: .activated,
            primaryAccountIdentifier: "id_1"
        )
        mockLibrary.passesToReturn = [pass]
        mockLibrary.canAddPassToWatch = ["id_1": true]
        
        let provider = ProvisioningStatusProvider(lastDigitsList: [blueLastDigits], passLibrary: mockLibrary)
        
        let status = await withCheckedContinuation { continuation in
            Task { @MainActor in
                provider.status { status in
                    continuation.resume(returning: status)
                }
            }
        }
        
        #expect(status.passEntriesAvailable == false)
        #expect(status.remotePassEntriesAvailable == true)
    }
    
    @Test
    func performanceConstraint() async throws {
        let mockLibrary = MockPassLibrary()
        let pass = MockSecureElementPass(
            primaryAccountNumberSuffix: blueLastDigits,
            passActivationState: .activated,
            primaryAccountIdentifier: "id_1"
        )
        mockLibrary.passesToReturn = [pass]
        mockLibrary.canAddPassToWatch = ["id_1": true]
        
        let provider = ProvisioningStatusProvider(lastDigitsList: [blueLastDigits], passLibrary: mockLibrary)
        
        let startTime = Date()
        
        let _ = await withCheckedContinuation { continuation in
            Task { @MainActor in
                provider.status { status in
                    continuation.resume(returning: status)
                }
            }
        }
        
        let elapsedTime = Date().timeIntervalSince(startTime)
        #expect(elapsedTime < 0.1, "The function must respond within 100ms")
    }
}
