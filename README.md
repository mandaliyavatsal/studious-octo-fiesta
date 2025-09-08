# Offline AI Assistant for macOS Apple Silicon

A privacy-focused, offline AI assistant application designed specifically for Apple Silicon Macs. This app automatically downloads and configures AI models locally, ensuring your conversations remain private while providing intelligent assistance.

## Features

- **🔒 Completely Offline**: All AI processing happens locally on your Mac
- **🛡️ Privacy-First**: No data sent to external servers, conversations stay on your device
- **⚡ Apple Silicon Optimized**: Built specifically for M1, M2, and M3 Macs
- **🤖 Automatic Setup**: Downloads and configures AI models automatically on first launch
- **💬 Modern Interface**: Clean, native macOS chat interface
- **📱 Native Performance**: Built with Swift and SwiftUI for optimal performance

## System Requirements

- macOS 13.0 (Ventura) or later
- Apple Silicon Mac (M1, M2, M3, or later)
- At least 2GB of free disk space for AI models
- Internet connection for initial model download only

## Installation

### Option 1: Build from Source

1. Clone this repository:
   ```bash
   git clone https://github.com/mandaliyavatsal/studious-octo-fiesta.git
   cd studious-octo-fiesta
   ```

2. Run the build script:
   ```bash
   ./build.sh
   ```

3. Copy the built app to your Applications folder:
   ```bash
   cp -R dist/OfflineAIAssistant.app /Applications/
   ```

### Option 2: Direct Installation (if pre-built)

1. Download the latest release
2. Copy `OfflineAIAssistant.app` to your Applications folder
3. Double-click to launch

## First Launch

On the first launch, the app will:

1. Create necessary directories in your Application Support folder
2. Download the TinyLlama 1.1B model (approximately 669MB)
3. Configure the AI engine for optimal performance
4. Present you with a ready-to-use chat interface

The download process includes a progress indicator and should complete within a few minutes depending on your internet connection.

## Architecture

The app consists of several key components:

### Core Components

- **OfflineAIAssistantApp.swift**: Main application entry point
- **ContentView.swift**: Primary view controller with initialization logic
- **ChatView.swift**: Chat interface and message handling
- **AIEngine.swift**: AI inference engine and model management
- **ModelDownloader.swift**: Automatic model downloading and caching

### AI Model

The app uses TinyLlama 1.1B, a lightweight but capable language model that:
- Provides good performance on Apple Silicon
- Requires minimal system resources
- Offers decent conversational abilities
- Can be run entirely offline

## Usage

### Basic Chat

Simply type your questions or requests in the text field and press Enter or click Send. The AI can help with:

- **General Questions**: Ask about various topics
- **Writing Assistance**: Help with writing, editing, and proofreading
- **Code Help**: Explain code concepts, debug issues, or write simple programs
- **Creative Tasks**: Story writing, brainstorming, and creative problem solving

### Example Conversations

```
You: Hello! How can you help me?
AI: Hello! I'm your offline AI assistant running locally on your Mac. I can help with answering questions, writing assistance, coding help, and general conversation. What would you like to work on?

You: Can you help me write a Python function?
AI: I'd be happy to help with Python! What kind of function would you like to create? Please describe what you want it to do.
```

## Technical Details

### Model Storage

Models are stored in:
```
~/Library/Application Support/OfflineAIAssistant/Models/
```

### Privacy & Security

- **No Network Calls**: After initial setup, no internet connection required
- **Local Processing**: All AI inference happens on your device
- **Sandboxed**: App runs in macOS sandbox for security
- **No Telemetry**: No usage data collected or transmitted

### Performance

- **Memory Usage**: Typically 1-2GB during active use
- **CPU Usage**: Optimized for Apple Silicon architecture
- **Response Time**: Usually 1-3 seconds for typical queries
- **Storage**: ~800MB total (app + model)

## Building and Development

### Prerequisites

- Xcode 15.0 or later
- macOS 13.0 SDK or later
- Apple Silicon Mac for testing

### Build Instructions

1. Open `OfflineAIAssistant/OfflineAIAssistant.xcodeproj` in Xcode
2. Select "OfflineAIAssistant" scheme
3. Ensure target is set to "Any Mac (Apple Silicon)"
4. Build and run (⌘+R)

Alternatively, use the provided build script:
```bash
./build.sh
```

### Project Structure

```
OfflineAIAssistant/
├── OfflineAIAssistant.xcodeproj/    # Xcode project file
├── OfflineAIAssistant/              # Source code
│   ├── OfflineAIAssistantApp.swift  # App entry point
│   ├── ContentView.swift            # Main view
│   ├── ChatView.swift               # Chat interface
│   ├── AIEngine.swift               # AI processing
│   ├── ModelDownloader.swift        # Model management
│   ├── Assets.xcassets              # App assets
│   └── OfflineAIAssistant.entitlements # App permissions
├── build.sh                         # Build script
└── README.md                        # This file
```

## Troubleshooting

### Model Download Issues

If the model download fails:
1. Check your internet connection
2. Restart the app to retry download
3. Manually delete the partial download and restart:
   ```bash
   rm -rf ~/Library/Application\ Support/OfflineAIAssistant/
   ```

### Performance Issues

If the app is slow:
1. Ensure you have sufficient free RAM (2GB+)
2. Close other memory-intensive applications
3. Restart the app

### Build Issues

If building from source fails:
1. Ensure Xcode command line tools are installed:
   ```bash
   xcode-select --install
   ```
2. Update to the latest Xcode version
3. Clean build folder (⌘+Shift+K in Xcode)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on Apple Silicon Mac
5. Submit a pull request

## License

This project is licensed under the Apache License 2.0. See the LICENSE file for details.

## Acknowledgments

- Built with Swift and SwiftUI
- Uses TinyLlama model architecture
- Inspired by privacy-focused AI applications

## Future Enhancements

Potential improvements for future versions:
- Support for multiple model options
- Conversation history persistence
- Export/import conversations
- Plugin system for extended functionality
- Voice input/output capabilities
- Integration with macOS shortcuts

---

For questions, issues, or feature requests, please open an issue on GitHub.