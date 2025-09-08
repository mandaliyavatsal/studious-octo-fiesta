import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
}

struct ChatView: View {
    @ObservedObject var aiEngine: AIEngine
    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    @State private var isProcessing = false
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.blue)
                Text("Offline AI Assistant")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text(aiEngine.modelInfo)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            // Chat messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(messages) { message in
                            ChatBubbleView(message: message)
                                .id(message.id)
                        }
                        
                        if isProcessing {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("AI is thinking...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input area
            HStack {
                TextField("Type your message here...", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        sendMessage()
                    }
                    .disabled(isProcessing)
                
                Button("Send") {
                    sendMessage()
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isProcessing)
            }
            .padding()
        }
        .onAppear {
            addWelcomeMessage()
        }
    }
    
    private func addWelcomeMessage() {
        if messages.isEmpty {
            let welcomeMessage = ChatMessage(
                content: "Hello! I'm your offline AI assistant. I'm running locally on your Mac, so your conversations stay private. How can I help you today?",
                isUser: false,
                timestamp: Date()
            )
            messages.append(welcomeMessage)
        }
    }
    
    private func sendMessage() {
        let userInput = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userInput.isEmpty, !isProcessing else { return }
        
        // Add user message
        let userMessage = ChatMessage(
            content: userInput,
            isUser: true,
            timestamp: Date()
        )
        messages.append(userMessage)
        inputText = ""
        isProcessing = true
        
        // Generate AI response
        Task {
            let response = await aiEngine.generateResponse(for: userInput)
            
            await MainActor.run {
                let aiMessage = ChatMessage(
                    content: response,
                    isUser: false,
                    timestamp: Date()
                )
                messages.append(aiMessage)
                isProcessing = false
            }
        }
    }
}

struct ChatBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading) {
                Text(message.content)
                    .padding(12)
                    .background(message.isUser ? Color.blue : Color(NSColor.controlBackgroundColor))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: 300, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser {
                Spacer()
            }
        }
    }
}

#Preview {
    ChatView(aiEngine: AIEngine())
}