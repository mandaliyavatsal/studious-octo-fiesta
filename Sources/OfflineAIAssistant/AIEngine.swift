import Foundation
#if canImport(Combine)
import Combine
#endif

#if canImport(Combine)
@MainActor
class AIEngine: ObservableObject {
    @Published var isModelReady = false
    @Published var downloadStatus = ""
    @Published var modelInfo = ""
    
    private let modelDownloader = ModelDownloader()
    private var llamaCppWrapper: LlamaCppWrapper?
    
    init() {
        modelInfo = "Not loaded"
    }
    
    func initialize() async {
        downloadStatus = "Checking for existing model..."
        
        if !modelDownloader.isModelDownloaded() {
            downloadStatus = "Model not found. Downloading..."
            do {
                try await modelDownloader.downloadModelWithProgress()
            } catch {
                downloadStatus = "Failed to download model: \(error.localizedDescription)"
                return
            }
        } else {
            downloadStatus = "Model found locally"
        }
        
        downloadStatus = "Loading model..."
        
        // Initialize the model
        do {
            let modelPath = modelDownloader.getModelPath()
            llamaCppWrapper = try LlamaCppWrapper(modelPath: modelPath.path)
            isModelReady = true
            modelInfo = "TinyLlama 1.1B"
            downloadStatus = "Ready!"
        } catch {
            downloadStatus = "Failed to load model: \(error.localizedDescription)"
            isModelReady = false
        }
    }
    
    func generateResponse(for prompt: String) async -> String {
        guard let wrapper = llamaCppWrapper else {
            return "AI model is not ready. Please restart the application."
        }
        
        let response = await wrapper.generateResponse(for: prompt)
        return response
    }
}
#else
// Non-Combine fallback for platforms without Combine support
class AIEngine {
    var isModelReady = false
    var downloadStatus = ""
    var modelInfo = ""
    
    private let modelDownloader = ModelDownloader()
    private var llamaCppWrapper: LlamaCppWrapper?
    
    init() {
        modelInfo = "Not loaded"
    }
    
    func initialize() async {
        downloadStatus = "Checking for existing model..."
        
        if !modelDownloader.isModelDownloaded() {
            downloadStatus = "Model not found. Would download if supported..."
        } else {
            downloadStatus = "Model found locally"
        }
        
        downloadStatus = "Loading model..."
        
        do {
            let modelPath = modelDownloader.getModelPath()
            llamaCppWrapper = try LlamaCppWrapper(modelPath: modelPath.path)
            isModelReady = true
            modelInfo = "TinyLlama 1.1B"
            downloadStatus = "Ready!"
        } catch {
            downloadStatus = "Failed to load model: \(error.localizedDescription)"
            isModelReady = false
        }
    }
    
    func generateResponse(for prompt: String) async -> String {
        guard let wrapper = llamaCppWrapper else {
            return "AI model is not ready. Please restart the application."
        }
        
        let response = await wrapper.generateResponse(for: prompt)
        return response
    }
}
#endif

// Mock LlamaCpp wrapper for now - this would integrate with actual llama.cpp
class LlamaCppWrapper {
    private let modelPath: String
    
    init(modelPath: String) throws {
        self.modelPath = modelPath
        
        // Verify the model file exists
        guard FileManager.default.fileExists(atPath: modelPath) else {
            throw AIEngineError.modelNotFound
        }
        
        // In a real implementation, this would initialize llama.cpp
        print("Initialized LlamaCpp with model at: \(modelPath)")
    }
    
    func generateResponse(for prompt: String) async -> String {
        // This is a mock implementation
        // In a real app, this would call into llama.cpp for actual inference
        
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate processing time
        
        // Return a mock response based on the prompt
        if prompt.lowercased().contains("hello") || prompt.lowercased().contains("hi") {
            return "Hello! I'm your offline AI assistant running locally on your Mac. How can I help you today?"
        } else if prompt.lowercased().contains("weather") {
            return "I'm an offline AI assistant, so I don't have access to real-time weather data. However, I can help you with many other tasks like answering questions, writing, coding assistance, and more!"
        } else if prompt.lowercased().contains("code") || prompt.lowercased().contains("programming") {
            return "I'd be happy to help with coding! I can assist with various programming languages, explain concepts, help debug code, or write simple programs. What specific programming task can I help you with?"
        } else if prompt.lowercased().contains("write") {
            return "I can help you with writing tasks! Whether it's creative writing, technical documentation, emails, or essays, I'm here to assist. What would you like to write?"
        } else {
            return "Thank you for your question! As an offline AI assistant, I'm here to help with various tasks including answering questions, writing assistance, coding help, and general conversation. While I don't have access to real-time information, I can help with knowledge-based tasks. Could you tell me more about what you'd like help with?"
        }
    }
}

enum AIEngineError: Error, LocalizedError {
    case modelNotFound
    case initializationFailed
    case inferenceError
    
    var errorDescription: String? {
        switch self {
        case .modelNotFound:
            return "AI model file not found"
        case .initializationFailed:
            return "Failed to initialize AI model"
        case .inferenceError:
            return "Error during AI inference"
        }
    }
}