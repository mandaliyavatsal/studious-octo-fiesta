import SwiftUI

struct ContentView: View {
    @StateObject private var aiEngine = AIEngine()
    @State private var isInitializing = true
    
    var body: some View {
        VStack {
            if isInitializing {
                InitializationView(aiEngine: aiEngine, isInitializing: $isInitializing)
            } else {
                ChatView(aiEngine: aiEngine)
            }
        }
        .frame(minWidth: 600, minHeight: 400)
        .onAppear {
            checkInitialization()
        }
    }
    
    private func checkInitialization() {
        if aiEngine.isModelReady {
            isInitializing = false
        }
    }
}

struct InitializationView: View {
    @ObservedObject var aiEngine: AIEngine
    @Binding var isInitializing: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Offline AI Assistant")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Setting up your AI assistant...")
                .font(.title2)
                .foregroundColor(.secondary)
            
            ProgressView()
                .scaleEffect(1.5)
                .padding()
            
            if !aiEngine.downloadStatus.isEmpty {
                Text(aiEngine.downloadStatus)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding(40)
        .onAppear {
            initializeAI()
        }
    }
    
    private func initializeAI() {
        Task {
            await aiEngine.initialize()
            await MainActor.run {
                isInitializing = false
            }
        }
    }
}

#Preview {
    ContentView()
}