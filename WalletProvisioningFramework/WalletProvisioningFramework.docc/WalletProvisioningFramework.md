# ``WalletProvisioningFramework``

A framework designed to help banks and card issuers implement the core logic for an Apple Pay Extension.

## Overview

By implementing this extension, an iOS app can declare the existence (or absence) of payment cards to be provisioned, provide the list of payment cards, and provide the data required for provisioning each card directly to the iOS Wallet app.

This framework focuses on evaluating the status of payment cards to declare whether cards are present or not. The primary entry point is the ``ProvisioningStatusProvider``, which checks the secure element pass library to determine the provisioning availability of your cards. It evaluates and declares two distinct statuses:
- The presence of cards to be provisioned on the **current iOS device**.
- The presence of cards to be provisioned on a **connected Apple Watch**.

## Topics

### Core Logic

- ``ProvisioningStatusProvider``

### Providers & Abstractions

- ``PassLibraryProvider``
- ``SecureElementPassProvider``