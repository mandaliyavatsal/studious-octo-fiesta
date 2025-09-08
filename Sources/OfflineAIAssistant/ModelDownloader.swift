import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(Combine)
import Combine
#endif

#if canImport(Combine)
class ModelDownloader: ObservableObject {
    @Published var downloadProgress: Double = 0.0
    @Published var downloadStatus: String = ""
    @Published var isDownloading: Bool = false
    
    private let modelsDirectory: URL
    
    // Model configuration - using a lightweight model for Apple Silicon
    private let modelConfig = ModelConfig(
        name: "tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf",
        url: "https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf",
        size: 669 * 1024 * 1024 // Approximately 669MB
    )
    
    init() {
        modelsDirectory = AppConfig.getModelsDirectory()
        
        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: modelsDirectory, withIntermediateDirectories: true)
    }
    
    func isModelDownloaded() -> Bool {
        let modelPath = modelsDirectory.appendingPathComponent(modelConfig.name)
        return FileManager.default.fileExists(atPath: modelPath.path)
    }
    
    func getModelPath() -> URL {
        return modelsDirectory.appendingPathComponent(modelConfig.name)
    }
    
    @MainActor
    func downloadModel() async throws {
        guard !isModelDownloaded() else {
            downloadStatus = "Model already downloaded"
            return
        }
        
        isDownloading = true
        downloadProgress = 0.0
        downloadStatus = "Starting download..."
        
        guard let url = URL(string: modelConfig.url) else {
            throw ModelDownloadError.invalidURL
        }
        
        let modelPath = getModelPath()
        
        do {
            downloadStatus = "Downloading TinyLlama model..."
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw ModelDownloadError.downloadFailed
            }
            
            downloadStatus = "Saving model to disk..."
            downloadProgress = 0.8
            
            try data.write(to: modelPath)
            
            downloadProgress = 1.0
            downloadStatus = "Model downloaded successfully"
            
        } catch {
            downloadStatus = "Download failed: \(error.localizedDescription)"
            throw error
        }
        
        isDownloading = false
    }
    
    @MainActor
    func downloadModelWithProgress() async throws {
        guard !isModelDownloaded() else {
            downloadStatus = "Model already downloaded"
            return
        }
        
        isDownloading = true
        downloadProgress = 0.0
        downloadStatus = "Starting download..."
        
        guard let url = URL(string: modelConfig.url) else {
            throw ModelDownloadError.invalidURL
        }
        
        let modelPath = getModelPath()
        
        do {
            downloadStatus = "Downloading TinyLlama model (669MB)..."
            
            let (tempURL, response) = try await URLSession.shared.download(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw ModelDownloadError.downloadFailed
            }
            
            downloadStatus = "Saving model to disk..."
            
            // Move the downloaded file to the final location
            if FileManager.default.fileExists(atPath: modelPath.path) {
                try FileManager.default.removeItem(at: modelPath)
            }
            try FileManager.default.moveItem(at: tempURL, to: modelPath)
            
            downloadProgress = 1.0
            downloadStatus = "Model downloaded successfully"
            
        } catch {
            downloadStatus = "Download failed: \(error.localizedDescription)"
            throw error
        }
        
        isDownloading = false
    }
}
#else
// Non-Combine fallback for platforms without Combine support
class ModelDownloader {
    var downloadProgress: Double = 0.0
    var downloadStatus: String = ""
    var isDownloading: Bool = false
    
    private let modelsDirectory: URL
    
    private let modelConfig = ModelConfig(
        name: "tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf",
        url: "https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf",
        size: 669 * 1024 * 1024
    )
    
    init() {
        modelsDirectory = AppConfig.getModelsDirectory()
        try? FileManager.default.createDirectory(at: modelsDirectory, withIntermediateDirectories: true)
    }
    
    func isModelDownloaded() -> Bool {
        let modelPath = modelsDirectory.appendingPathComponent(modelConfig.name)
        return FileManager.default.fileExists(atPath: modelPath.path)
    }
    
    func getModelPath() -> URL {
        return modelsDirectory.appendingPathComponent(modelConfig.name)
    }
    
    func downloadModel() async throws {
        // Simplified version for non-Combine platforms
        downloadStatus = "Model download not implemented for this platform"
        print("Model download would be implemented here")
    }
    
    func downloadModelWithProgress() async throws {
        try await downloadModel()
    }
}
#endif

struct ModelConfig {
    let name: String
    let url: String
    let size: Int64
}

enum ModelDownloadError: Error, LocalizedError {
    case invalidURL
    case downloadFailed
    case fileSystemError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid model URL"
        case .downloadFailed:
            return "Failed to download model"
        case .fileSystemError:
            return "File system error"
        }
    }
}