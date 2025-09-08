#!/bin/bash

# Build script for Offline AI Assistant for macOS Apple Silicon
# This script builds the app and creates a distributable .app bundle

set -e

echo "🔨 Building Offline AI Assistant..."

# Ensure we're in the right directory
cd "$(dirname "$0")"

# Check if we have xcodebuild (macOS) or use Swift Package Manager (Linux/other)
if command -v xcodebuild &> /dev/null; then
    echo "📱 Building macOS app with Xcode..."
    cd OfflineAIAssistant

    xcodebuild \
        -project OfflineAIAssistant.xcodeproj \
        -scheme OfflineAIAssistant \
        -configuration Release \
        -arch arm64 \
        ARCHS=arm64 \
        ONLY_ACTIVE_ARCH=NO \
        clean build

    echo "✅ macOS app build completed successfully!"

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

elif command -v swift &> /dev/null; then
    echo "🔧 Building cross-platform library with Swift Package Manager..."
    
    swift build
    
    echo "✅ Library build completed successfully!"
    echo "📦 Library built in .build directory"
    
    # Create a distributable version
    DIST_DIR="dist"
    mkdir -p "$DIST_DIR"
    
    # Copy the library files for distribution
    echo "📋 Creating distribution package..."
    cp -R Sources "$DIST_DIR/"
    cp Package.swift "$DIST_DIR/"
    cp demo_main.swift "$DIST_DIR/"
    
    echo "📦 Distribution package created in: $DIST_DIR/"
    
    # Create a README for the library distribution
    cat > "$DIST_DIR/README.md" << 'EOF'
# Offline AI Assistant - Cross-Platform Library

This is a cross-platform Swift library version of the Offline AI Assistant.

## Building

```bash
swift build
```

## Usage

The library provides the core AI engine functionality that can be integrated into:
- macOS applications (using the original Xcode project)
- iOS applications
- Command-line tools
- Other Swift applications

## Core Components

- `AIEngine`: Main AI processing engine
- `ModelDownloader`: Handles downloading and caching of AI models
- `AppConfig`: Configuration and system information utilities

## Demo

A console demo is available in `demo_main.swift`. To run it:

```bash
# Copy the demo file to a new executable project
swift package init --type executable --name OfflineAIDemo
# Copy the source files and demo_main.swift
# Then build and run
```

Enjoy your offline AI assistant library!
EOF

    echo "📝 Created library distribution with README.md"
    
else
    echo "❌ Error: Neither Xcode nor Swift Package Manager found."
    echo "Please install Xcode (macOS) or Swift (other platforms)"
    exit 1
fi

echo "🎉 Build and packaging complete!"