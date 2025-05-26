//
//  OllamaService.swift
//  Biography
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import Foundation
import Combine

// MARK: - Data Models for OpenAI-compatible API
struct ChatCompletionRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    let temperature: Double
    let max_tokens: Int
    
    struct ChatMessage: Codable {
        let role: String
        let content: String
    }
}

struct ChatCompletionResponse: Codable {
    let id: String
    let object: String
    let model: String
    let choices: [Choice]
    
    struct Choice: Codable {
        let index: Int
        let message: ChatMessage
        let finish_reason: String
        
        struct ChatMessage: Codable {
            let role: String
            let content: String
        }
    }
}

struct ModelsResponse: Codable {
    let models: [ModelInfo]
    
    struct ModelInfo: Codable {
        let name: String
        let size: Int64?
        let digest: String?
        let details: ModelDetails?
        
        struct ModelDetails: Codable {
            let families: [String]?
        }
    }
}

class OllamaService: @unchecked Sendable {
    static let shared = OllamaService()
    
    private let baseURL = "http://10.7.3.52:3000"
    private let session = URLSession.shared
    
    init() {
        // No initialization needed for direct HTTP calls
    }
    
    func initEndpoint(url: String? = nil, bearerToken: String? = nil) {
        // This method is kept for compatibility but doesn't do anything
        // since we're hardcoded to use localhost:3000
    }
    
    func getModels() async throws -> [LanguageModel] {
        let url = URL(string: "\(baseURL)/v1/models")!
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let modelsResponse = try JSONDecoder().decode(ModelsResponse.self, from: data)
        
        let models = modelsResponse.models.map { modelInfo in
            LanguageModel(
                name: modelInfo.name,
                provider: .ollama,
                imageSupport: modelInfo.details?.families?.contains(where: { $0 == "clip" || $0 == "mllama" }) ?? false
            )
        }
        
        return models
    }
    
    func reachable() async -> Bool {
        do {
            let url = URL(string: "\(baseURL)/health")!
            let (_, response) = try await session.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
            return false
        } catch {
            return false
        }
    }
    
    // MARK: - Chat Completion
    func chat(model: String, messages: [ChatCompletionRequest.ChatMessage], temperature: Double = 0.7) -> AnyPublisher<String, Error> {
        let subject = PassthroughSubject<String, Error>()
        
        Task {
            do {
                let request = ChatCompletionRequest(
                    model: model,
                    messages: messages,
                    temperature: temperature,
                    max_tokens: 150
                )
                
                let url = URL(string: "\(baseURL)/v1/chat/completions")!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "POST"
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = try JSONEncoder().encode(request)
                
                let (data, response) = try await session.data(for: urlRequest)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    subject.send(completion: .failure(URLError(.badServerResponse)))
                    return
                }
                
                let chatResponse = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
                
                if let choice = chatResponse.choices.first {
                    // Send the complete response at once
                    subject.send(choice.message.content)
                    subject.send(completion: .finished)
                } else {
                    subject.send(completion: .failure(URLError(.cannotParseResponse)))
                }
                
            } catch {
                subject.send(completion: .failure(error))
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
}

// MARK: - Compatibility structures for existing code
struct OKChatRequestData {
    let model: String
    let messages: [Message]
    var options: OKCompletionOptions?
    
    struct Message {
        let role: Role
        let content: String
        let images: [String]?
        
        init(role: Role, content: String, images: [String]? = nil) {
            self.role = role
            self.content = content
            self.images = images
        }
        
        enum Role: String {
            case user = "user"
            case assistant = "assistant"
            case system = "system"
        }
    }
}

struct OKCompletionOptions {
    let temperature: Double
}

struct OKChatResponse {
    let message: Message?
    
    struct Message {
        let content: String
    }
}

// MARK: - Extension to provide OllamaKit-compatible interface
extension OllamaService {
    func chat(data: OKChatRequestData) -> AnyPublisher<OKChatResponse, Error> {
        let messages = data.messages.map { message in
            ChatCompletionRequest.ChatMessage(
                role: message.role.rawValue,
                content: message.content
            )
        }
        
        let temperature = data.options?.temperature ?? 0.7
        
        return chat(model: data.model, messages: messages, temperature: temperature)
            .map { content in
                OKChatResponse(message: OKChatResponse.Message(content: content))
            }
            .eraseToAnyPublisher()
    }
}
