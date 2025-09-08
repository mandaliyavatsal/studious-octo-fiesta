#!/bin/bash

# Build script for Offline AI Assistant for macOS Apple Silicon
# This script builds the app and creates a distributable .app bundle

set -e

echo "🔨 Building Offline AI Assistant for macOS Apple Silicon..."

# Ensure we're in the right directory
cd "$(dirname "$0")"

# Check if Xcode command line tools are installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode command line tools are not installed."
    echo "Please install them with: xcode-select --install"
    exit 1
fi

# Build the project
echo "📱 Building the app..."
cd OfflineAIAssistant

xcodebuild \
    -project OfflineAIAssistant.xcodeproj \
    -scheme OfflineAIAssistant \
    -configuration Release \
    -arch arm64 \
    ARCHS=arm64 \
    ONLY_ACTIVE_ARCH=NO \
    clean build

echo "✅ Build completed successfully!"

# Find the built app
BUILT_APP=$(find . -name "OfflineAIAssistant.app" -path "*/Build/Products/Release/*" | head -n 1)

if [ -z "$BUILT_APP" ]; then
    echo "❌ Error: Could not find the built app"
    exit 1
fi

echo "📦 App built at: $BUILT_APP"

# Copy to a distributable location
DIST_DIR="../dist"
mkdir -p "$DIST_DIR"
rm -rf "$DIST_DIR/OfflineAIAssistant.app"
cp -R "$BUILT_APP" "$DIST_DIR/"

echo "📋 App copied to: $DIST_DIR/OfflineAIAssistant.app"

# Create a simple installer
cat > "$DIST_DIR/README.md" << EOF
# Offline AI Assistant for macOS

## Installation

1. Copy OfflineAIAssistant.app to your Applications folder
2. Double-click to launch the app
3. On first launch, the app will automatically download the AI model (approximately 669MB)
4. Once the model is downloaded, you can start chatting with your offline AI assistant

## Features

- Completely offline AI assistant
- Privacy-focused: all conversations stay on your Mac
- Optimized for Apple Silicon (M1/M2/M3 Macs)
- Automatic model downloading and configuration
- Modern macOS interface

## System Requirements

- macOS 13.0 or later
- Apple Silicon Mac (M1, M2, M3, or later)
- At least 2GB of free disk space for the AI model
- Internet connection for initial model download

## Usage

Simply type your questions or requests in the chat interface. The AI assistant can help with:
- Answering questions
- Writing assistance
- Code explanations and help
- General conversation

Enjoy your private, offline AI assistant!
EOF

echo "📝 Created README.md with installation instructions"
echo "🎉 Build and packaging complete!"
echo ""
echo "To distribute the app:"
echo "1. Share the entire 'dist' folder"
echo "2. Users should copy OfflineAIAssistant.app to their Applications folder"
echo "3. The app will automatically download models on first launch"