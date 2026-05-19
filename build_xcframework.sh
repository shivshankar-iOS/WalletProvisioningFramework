#!/bin/sh

PROJECT_NAME="WalletProvisioningFramework"
SCHEME_NAME="WalletProvisioningFramework"
BUILD_DIR="./build"

echo "Cleaning up build directory..."
rm -rf "$BUILD_DIR"

echo "Building for iOS Simulator..."
xcodebuild archive \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$SCHEME_NAME" \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "$BUILD_DIR/$PROJECT_NAME-iphonesimulator.xcarchive" \
    -sdk iphonesimulator \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "Building for iOS Device..."
xcodebuild archive \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$SCHEME_NAME" \
    -destination "generic/platform=iOS" \
    -archivePath "$BUILD_DIR/$PROJECT_NAME-iphoneos.xcarchive" \
    -sdk iphoneos \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "Creating XCFramework..."
xcodebuild -create-xcframework \
    -framework "$BUILD_DIR/$PROJECT_NAME-iphoneos.xcarchive/Products/Library/Frameworks/$PROJECT_NAME.framework" \
    -framework "$BUILD_DIR/$PROJECT_NAME-iphonesimulator.xcarchive/Products/Library/Frameworks/$PROJECT_NAME.framework" \
    -output "$BUILD_DIR/$PROJECT_NAME.xcframework"

echo "Successfully created $PROJECT_NAME.xcframework in $BUILD_DIR"
