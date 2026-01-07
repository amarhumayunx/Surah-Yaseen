#!/bin/bash

# Script to upload iOS IPA to GitHub Releases
# Make sure you have the IPA file ready

VERSION="v1.0.0"
IPA_PATH="releases/ios/Runner.ipa"

# Check if IPA file exists
if [ ! -f "$IPA_PATH" ]; then
    echo "❌ IPA file not found at: $IPA_PATH"
    echo ""
    echo "Please follow these steps:"
    echo "1. Build iOS app in Xcode (see ios_build_instructions.md)"
    echo "2. Export IPA file"
    echo "3. Copy IPA to: $IPA_PATH"
    echo "4. Run this script again"
    exit 1
fi

echo "📱 Uploading iOS IPA to GitHub Release: $VERSION"
echo "File: $IPA_PATH"

# Upload to existing release
gh release upload "$VERSION" "$IPA_PATH" --clobber

if [ $? -eq 0 ]; then
    echo "✅ iOS app uploaded successfully!"
    echo "Release URL: https://github.com/amarhumayunx/Surah-Yaseen/releases/tag/$VERSION"
else
    echo "❌ Upload failed. Please check your authentication and try again."
    exit 1
fi

