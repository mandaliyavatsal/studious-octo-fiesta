# GitHub Actions Workflows

This directory contains GitHub Actions workflows for automated building, testing, and releasing of the Offline AI Assistant project.

## Workflows

### 1. CI Workflow (`ci.yml`)

**Triggers:** Push to `main` or `develop` branches, Pull Requests to these branches

**Purpose:** Continuous Integration - builds and tests the code to ensure it works correctly

**Jobs:**
- **test-swift-package (Linux)**: Tests the Swift Package Manager library on Ubuntu Linux
- **test-swift-package-macos**: Tests the Swift Package Manager library on macOS  
- **build-macos-app**: Builds the complete macOS application using Xcode

**Artifacts:** macOS app build artifacts are uploaded and retained for 30 days

### 2. Release Workflow (`release.yml`)

**Triggers:** Push of version tags (e.g., `v1.0.0`, `v2.1.3`)

**Purpose:** Automated release creation with built artifacts

**What it does:**
1. Builds both the Swift library and macOS app
2. Creates distribution packages:
   - `OfflineAIAssistant-{version}-macOS.zip`: Complete macOS application
   - `OfflineAIAssistant-Library-{version}.zip`: Swift package library for developers
3. Creates a GitHub release with:
   - Release notes extracted from commit messages
   - Download links and installation instructions
   - System requirements

**Artifacts:** Both packages are attached to the GitHub release

### 3. Validate Workflow (`validate.yml`)

**Triggers:** Changes to workflow files in `.github/workflows/`

**Purpose:** Validates that workflow YAML files are syntactically correct

## Creating a Release

To create a new release:

1. Update version numbers in your code if needed
2. Commit and push your changes
3. Create and push a version tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
4. The release workflow will automatically:
   - Build the project
   - Create a GitHub release
   - Upload the distribution packages

## Requirements

- **macOS runners**: Required for building the macOS application (Xcode needed)
- **Linux runners**: Used for testing cross-platform Swift Package Manager builds
- **Permissions**: The release workflow needs `contents: write` permission to create releases

## Build Artifacts

The workflows create several types of artifacts:

- **CI Artifacts**: Temporary build outputs for testing (30-day retention)
- **Release Artifacts**: Permanent distribution packages attached to GitHub releases:
  - macOS app bundle (`.app` in `.zip`)
  - Swift library source package (`.zip`)

## Notes

- The macOS app requires Apple Silicon (ARM64) and will only run on M1/M2/M3 Macs
- The Swift library is cross-platform and can be used on Linux, macOS, and other Swift-supported platforms
- First-time app users will need to download AI models (handled automatically by the app)
- Build times may vary based on GitHub Actions runner availability