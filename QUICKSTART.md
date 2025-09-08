# Quick Start Guide

## For End Users

### Installation
1. Download or build the app
2. Copy `OfflineAIAssistant.app` to your Applications folder
3. Double-click to launch
4. Wait for automatic model download (~669MB)
5. Start chatting with your AI assistant!

## For Developers

### Building from Source
```bash
# Clone the repository
git clone https://github.com/mandaliyavatsal/studious-octo-fiesta.git
cd studious-octo-fiesta

# Build the app
./build.sh

# Install to Applications
cp -R dist/OfflineAIAssistant.app /Applications/
```

### System Requirements
- macOS 13.0+ (Ventura or later)
- Apple Silicon Mac (M1/M2/M3)
- 2GB+ free disk space
- Internet connection for initial model download

### What's Included
- Native Swift/SwiftUI macOS app
- Automatic TinyLlama 1.1B model downloading
- Privacy-focused offline operation
- Modern chat interface
- Complete build and distribution system

### First Launch
The app will automatically:
1. Create necessary directories
2. Download the AI model (TinyLlama 1.1B, ~669MB)
3. Initialize the inference engine
4. Present a ready-to-use chat interface

No manual configuration required!

## Architecture

### Key Components
- **OfflineAIAssistantApp.swift**: Main app entry point
- **ContentView.swift**: Initialization and main view logic
- **ChatView.swift**: Chat interface with message bubbles
- **AIEngine.swift**: AI inference and model management
- **ModelDownloader.swift**: Automatic model downloading with progress

### Privacy & Security
- All processing happens locally on your Mac
- No data sent to external servers after initial setup
- Models stored in `~/Library/Application Support/OfflineAIAssistant/`
- App runs in macOS sandbox for security

### Performance
- Optimized for Apple Silicon architecture
- Typical response time: 1-3 seconds
- Memory usage: ~1.5GB during active use
- CPU efficient with native arm64 code

Enjoy your private, offline AI assistant! 🤖