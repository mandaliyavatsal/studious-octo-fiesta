import Foundation

struct AppConfig {
    // Model Configuration
    static let defaultModelName = "tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf"
    static let defaultModelURL = "https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf"
    static let modelSizeBytes: Int64 = 669 * 1024 * 1024 // 669MB
    
    // Alternative models that users could potentially use
    static let alternativeModels = [
        ModelOption(
            name: "phi-2-dpo-gguf",
            displayName: "Phi-2 DPO (2.7B)",
            url: "https://huggingface.co/microsoft/phi-2/resolve/main/model.gguf",
            size: 1600 * 1024 * 1024,
            description: "Larger, more capable model"
        ),
        ModelOption(
            name: "tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf",
            displayName: "TinyLlama 1.1B (Default)",
            url: defaultModelURL,
            size: modelSizeBytes,
            description: "Lightweight, fast model optimized for Apple Silicon"
        )
    ]
    
    // UI Configuration
    static let windowMinWidth: Double = 600
    static let windowMinHeight: Double = 400
    static let chatBubbleMaxWidth: Double = 300
    
    // Performance Configuration
    static let maxContextLength = 2048
    static let responseTimeoutSeconds = 30.0
    static let memoryWarningThresholdMB = 4096
    
    // Storage Configuration
    static let appSupportDirectoryName = "OfflineAIAssistant"
    static let modelsSubdirectoryName = "Models"
    static let logsSubdirectoryName = "Logs"
    
    // Network Configuration
    static let downloadTimeoutSeconds = 300.0 // 5 minutes
    static let downloadRetryAttempts = 3
    
    // Privacy Configuration
    static let enableConversationLogging = false
    static let enableTelemetry = false
    static let enableCrashReporting = false
}

struct ModelOption {
    let name: String
    let displayName: String
    let url: String
    let size: Int64
    let description: String
}

// MARK: - Runtime Configuration
extension AppConfig {
    static func getModelsDirectory() -> URL {
        #if os(macOS)
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        #else
        let appSupport = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(".local/share")
        #endif
        return appSupport
            .appendingPathComponent(appSupportDirectoryName)
            .appendingPathComponent(modelsSubdirectoryName)
    }
    
    static func getLogsDirectory() -> URL {
        #if os(macOS)
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        #else
        let appSupport = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(".local/share")
        #endif
        return appSupport
            .appendingPathComponent(appSupportDirectoryName)
            .appendingPathComponent(logsSubdirectoryName)
    }
    
    static func getDefaultModelPath() -> URL {
        return getModelsDirectory().appendingPathComponent(defaultModelName)
    }
}

// MARK: - System Information
extension AppConfig {
    static func isAppleSilicon() -> Bool {
        #if os(macOS)
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let machine = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value))!)
        }
        return machine.contains("arm64")
        #else
        // On non-macOS platforms, assume we're not on Apple Silicon
        return false
        #endif
    }
    
    static func getAvailableMemoryMB() -> Int64 {
        #if os(macOS)
        let host = mach_host_self()
        var hostInfo = host_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<host_basic_info>.size/MemoryLayout<integer_t>.size)
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                host_info(host, HOST_BASIC_INFO, $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return Int64(hostInfo.memory_size) / (1024 * 1024)
        }
        #endif
        return 0
    }
}