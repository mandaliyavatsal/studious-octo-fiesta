import Foundation

// Simple console-based version of the Offline AI Assistant
// This demonstrates the core functionality without requiring SwiftUI/macOS

struct ConsoleAIAssistant {
    private let aiEngine = AIEngine()
    
    func run() async {
        print("🤖 Offline AI Assistant - Console Version")
        print("========================================")
        print()
        
        print("Initializing AI engine...")
        await aiEngine.initialize()
        
        if !aiEngine.isModelReady {
            print("❌ Failed to initialize AI engine: \(aiEngine.downloadStatus)")
            return
        }
        
        print("✅ AI engine ready! Model: \(aiEngine.modelInfo)")
        print("Type 'quit' to exit, or start chatting:")
        print()
        
        // Simple chat loop for testing
        var isRunning = true
        
        while isRunning {
            print("You: ", terminator: "")
            
            guard let input = readLine(), !input.isEmpty else {
                continue
            }
            
            if input.lowercased() == "quit" {
                isRunning = false
                print("👋 Goodbye!")
                break
            }
            
            print("AI: ", terminator: "")
            print("thinking...")
            
            let response = await aiEngine.generateResponse(for: input)
            
            // Clear the "thinking..." line and print response
            print("\u{1B}[1A\u{1B}[K", terminator: "")  // Move up and clear line
            print("AI: \(response)")
            print()
        }
    }
}

// Entry point
Task {
    let assistant = ConsoleAIAssistant()
    await assistant.run()
}