# WalletProvisioningFramework

## Overview
`WalletProvisioningFramework` is an iOS framework designed to help banks and card issuers implement the core logic for an **Apple Pay Extension** (`PKIssuerProvisioningExtensionHandler`).

By implementing this extension, an iOS app can declare the existence (or absence) of payment cards to be provisioned, provide the list of payment cards, and provide the data required for provisioning each card directly to the iOS Wallet app.

This framework focuses on evaluating the status of payment cards to declare whether cards are present or not. The primary entry point is the `ProvisioningStatusProvider`, which checks the secure element pass library to determine the provisioning availability of your cards. It evaluates and declares two distinct statuses:
- The presence of cards to be provisioned on the **current iOS device** (via `passEntriesAvailable`).
- The presence of cards to be provisioned on a **connected Apple Watch** (via `remotePassEntriesAvailable`).

## Features
- Detects whether cards already exist on the current device
- Detects whether cards can still be provisioned on Apple Watch
- Uses PassKit and Secure Element passes
- Protocol-oriented and unit-test friendly architecture
- Optimized to satisfy the Wallet extension performance requirement (<100ms)
- XCFramework build support included

### Implementation Logic
To determine if a card can be provisioned, the `ProvisioningStatusProvider` compares a list of `lastDigits` with the properties of existing Secure Element Passes:
1. **Match Detection:** It matches `lastDigits` against the `primaryAccountNumberSuffix` of a `PKSecureElementPass`.
2. **Device Availability:** If no match is found, or if a matching card is entirely deactivated, the card is not present on the current device, meaning it is **possible to add it** (`passEntriesAvailable = true`).
3. **Apple Watch Availability:** If a match is found and its state is not deactivated, the card is already present on the device. The framework then checks if it can still be provisioned on a connected Apple Watch using `canAddSecureElementPass`. If so, `remotePassEntriesAvailable = true`.
4. **Performance Constraint:** The `status` function must respond to the Wallet app within **100ms**. The framework is built and tested to ensure this constraint is strictly met.

## Generating the XCFramework
This project includes a shell script to automate the process of building a pre-compiled `.xcframework` that supports both the iOS Simulator and iOS Devices.

To generate the XCFramework:
1. Open your terminal and navigate to the project's root folder (`WalletProvisioningFramework`).
2. Run the provided build script:
   ```bash
   ./build_xcframework.sh
   ```
3. Once the script successfully completes, the pre-compiled framework will be available at:
   `build/WalletProvisioningFramework.xcframework`

## Integration Guide
### Add the XCFramework
1. Open your Xcode project
2. Drag and drop `WalletProvisioningFramework.xcframework` into the project navigator
3. Add it under **Frameworks, Libraries, and Embedded Content**
4. Ensure the framework is correctly linked. If using a dynamic framework configuration, select **Embed & Sign**.

## Usage Example
```swift
import SwiftUI
import WalletProvisioningFramework

struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("Checking Apple Pay Provisioning Status...")
        }
        .onAppear {
            
            let provider = ProvisioningStatusProvider(
                lastDigitsList: [
                    "1234",
                    "5678"
                ]
            )
            
            provider.status { status in
                
                print("Pass Entries Available:")
                print(status.passEntriesAvailable)
                
                print("Remote Pass Entries Available:")
                print(status.remotePassEntriesAvailable)
                
                print("Requires Authentication:")
                print(status.requiresAuthentication)
            }
        }
    }
}
```

### Requirements
- **iOS:** 13.0+ (or as specified in the framework target)
- **Frameworks:** `PassKit` (Requires a physical device or appropriately configured simulator for full PassKit evaluation).

## Running Tests
To run the automated tests for this framework and verify the performance constraints (e.g., the 100ms response time limit):
1. Open the project in Xcode.
2. Select the `WalletProvisioningFramework` scheme.
3. Press `Cmd + U` or navigate to **Product > Test** in the menu bar.

### Test Coverage
The automated test suite validates multiple provisioning scenarios, including:
- No cards available on device
- Card already provisioned on iPhone
- Card eligible for Apple Watch provisioning
- Deactivated cards
- Multiple mixed card states
- Performance constraint validation (<100ms)

The framework uses mocked `PKPassLibrary` interactions to ensure deterministic and isolated unit testing.

## Author
Developed by Shivshankar Gupta.
