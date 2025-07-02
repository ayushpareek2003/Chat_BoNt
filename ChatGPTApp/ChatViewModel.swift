import Foundation
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let apiService: APIService
    
    init(apiKey: String) {
        self.apiService = APIService(apiKey: apiKey)
        
        // Add welcome message
        messages.append(Message(
            content: "Hello! I'm your AI assistant. How can I help you today?",
            isUser: false
        ))
    }
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = Message(content: inputText, isUser: true)
        messages.append(userMessage)
        
        let userInput = inputText
        inputText = ""
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let chatMessages = messages.map { message in
                    ChatMessage(
                        role: message.isUser ? "user" : "assistant",
                        content: message.content
                    )
                }
                
                let response = try await apiService.sendMessage(chatMessages)
                
                let assistantMessage = Message(content: response, isUser: false)
                messages.append(assistantMessage)
                
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    func clearChat() {
        messages.removeAll()
        messages.append(Message(
            content: "Hello! I'm your AI assistant. How can I help you today?",
            isUser: false
        ))
        errorMessage = nil
    }
} 