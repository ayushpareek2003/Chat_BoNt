import Foundation

class APIService: ObservableObject {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func sendMessage(_ messages: [ChatMessage]) async throws -> String {
        guard let url = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        let request = ChatRequest(
            model: "gpt-3.5-turbo",
            messages: messages,
            temperature: 0.7,
            maxTokens: 1000
        )
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            throw APIError.encodingError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            if httpResponse.statusCode != 200 {
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
            
            guard let firstChoice = chatResponse.choices.first else {
                throw APIError.noResponse
            }
            
            return firstChoice.message.content
            
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case encodingError
    case invalidResponse
    case httpError(statusCode: Int)
    case noResponse
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .encodingError:
            return "Failed to encode request"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .noResponse:
            return "No response from API"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
} 