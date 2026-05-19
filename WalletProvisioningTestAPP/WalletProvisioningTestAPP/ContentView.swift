//
//  ContentView.swift
//  WalletProvisioningTestAPP
//
//  Created by Shivra on 19/05/26.
//

import SwiftUI
import WalletProvisioningFramework
import PassKit

struct ContentView: View {
    
    @State private var message: String = "Tap the button to check Apple Pay provisioning status."
    
    var body: some View {
        VStack(spacing: 16) {
            Text(message)
                .multilineTextAlignment(.center)
            
            Button("Check Provisioning Status") {
                checkProvisioningStatus()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func checkProvisioningStatus() {
        message = "Checking Apple Pay provisioning status..."
        
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
            
            DispatchQueue.main.async {
                message = """
                Pass Entries Available: \(status.passEntriesAvailable)
                Remote Pass Entries Available: \(status.remotePassEntriesAvailable)
                Requires Authentication: \(status.requiresAuthentication)
                """
            }
        }
    }
}

#Preview {
    ContentView()
}
