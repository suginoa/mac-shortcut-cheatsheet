#!/bin/bash
# 必要環境: Xcode Command Line Tools (xcode-select --install)
set -e

APP_NAME="ShortcutCheatSheet"
BUILD_DIR=".build"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"

echo "Building $APP_NAME..."

mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

SDK_PATH=$(xcrun --show-sdk-path)
ARCH=$(uname -m)
# SDKのバージョンからターゲットを自動取得
SDK_VERSION=$(xcrun --show-sdk-version 2>/dev/null | cut -d. -f1-2)
TARGET="${ARCH}-apple-macos${SDK_VERSION}"

swiftc Sources/*.swift \
    -o "$APP_BUNDLE/Contents/MacOS/$APP_NAME" \
    -sdk "$SDK_PATH" \
    -target "$TARGET" \
    -framework AppKit \
    -framework SwiftUI

cp Info.plist "$APP_BUNDLE/Contents/"

echo "Done: $APP_BUNDLE"
echo "Run:  open $APP_BUNDLE"
