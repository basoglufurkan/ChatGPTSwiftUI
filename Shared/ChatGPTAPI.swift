//
//  ChatGPTAPI.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 01/02/23.
//

import Foundation

class ChatGPTAPI: @unchecked Sendable {
    
    private let systemMessage: Message
    private let temperature: Double
    private let model: String
    
    private let apiKey: String
    private var historyList = [Message]()
    private let urlSession = URLSession.shared
    private var urlRequest: URLRequest {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        headers.forEach {  urlRequest.setValue($1, forHTTPHeaderField: $0) }
        return urlRequest
    }
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }()
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    private var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
    }
    

    init(apiKey: String, model: String = "gpt-3.5-turbo", systemPrompt: String = "You are a helpful assistant", temperature: Double = 0.5) {
        self.apiKey = apiKey
        self.model = model
        self.systemMessage = .init(role: "system", content: systemPrompt)
        self.temperature = temperature
    }
    
    private func generateMessages(from text: String) -> [Message] {
        var messages = [systemMessage] + historyList + [Message(role: "user", content: text)]
        
        if messages.contentCount > (8000 * 4) {
            _ = historyList.removeFirst()
            messages = generateMessages(from: text)
        }
        return messages
    }
    
    private func jsonBody(text: String, stream: Bool = true) throws -> Data {
        let request = Request(model: model, temperature: temperature,
                              messages: generateMessages(from: text), stream: stream)
        return try JSONEncoder().encode(request)
    }
    
    private func appendToHistoryList(userText: String, responseText: String) {
        self.historyList.append(.init(role: "user", content: userText))
        self.historyList.append(.init(role: "assistant", content: responseText))
    }
    
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error> {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text)
        
        let (result, response) = try await urlSession.bytes(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw "Invalid response"
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            var errorText = ""
            for try await line in result.lines {
                errorText += line
            }
            
            if let data = errorText.data(using: .utf8), let errorResponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error {
                errorText = "\n\(errorResponse.message)"
            }
            
            throw "Bad Response: \(httpResponse.statusCode), \(errorText)"
        }
        
        return AsyncThrowingStream<String, Error> { continuation in
            Task(priority: .userInitiated) { [weak self] in
                guard let self else { return }
                do {
                    var responseText = ""
                    for try await line in result.lines {
                        if line.hasPrefix("data: "),
                           let data = line.dropFirst(6).data(using: .utf8),
                           let response = try? self.jsonDecoder.decode(StreamCompletionResponse.self, from: data),
                           let text = response.choices.first?.delta.content {
                            responseText += text
                            continuation.yield(text)
                        }
                    }
                    self.appendToHistoryList(userText: text, responseText: responseText)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    func sendMessage(_ text: String) async throws -> String {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text, stream: false)
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw "Invalid response"
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            var error = "Bad Response: \(httpResponse.statusCode)"
            if let errorResponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error {
                error.append("\n\(errorResponse.message)")
            }
            throw error
        }
        
        do {
            let completionResponse = try self.jsonDecoder.decode(CompletionResponse.self, from: data)
            let responseText = completionResponse.choices.first?.message.content ?? ""
            self.appendToHistoryList(userText: text, responseText: responseText)
            return responseText
        } catch {
            throw error
        }
    }
    
    func deleteHistoryList() {
        self.historyList.removeAll()
    }
}

extension String: CustomNSError {
    
    public var errorUserInfo: [String : Any] {
        [
            NSLocalizedDescriptionKey: self
        ]
    }
}




/*
 
 Bu kodlar, OpenAI API'sini kullanarak bir chatbot oluşturmak için tasarlanmış bir sınıf olan ChatGPTAPI'yi içerir. Bu sınıf, apiKey, model, systemPrompt ve temperature gibi parametreleri kabul eder ve sendMessage ve sendMessageStream gibi metotlarla birlikte geliyor.

 sendMessage metodu, kullanıcının gönderdiği metni OpenAI API'sine gönderir ve yanıtı döndürür. sendMessageStream metodu ise aynı işlemi yapar, ancak sonuçları bir akış halinde döndürür. Her iki metot da farklı hataların fırlatılması durumunda throw anahtar kelimesini kullanır.

 Ayrıca, deleteHistoryList metodu, daha önce yapılan sohbet geçmişini temizlemek için kullanılabilir.
 Kod, aşağıdaki temel bileşenlere sahiptir:

 systemMessage: Yardımcı asistanın sistem mesajını temsil eden bir Message nesnesi.
 temperature: Metin tamamlama sırasında kullanılan sıcaklık değerini temsil eden bir Double.
 model: Kullanılacak dil modelini temsil eden bir String.
 apiKey: OpenAI API'sine yetkilendirme yapmak için kullanılan bir API anahtarı.
 historyList: Sohbet geçmişini tutan bir Message dizisi.
 urlSession: URL işlemleri için kullanılan bir URLSession nesnesi.
 dateFormatter: Tarih formatını ayarlamak için kullanılan bir DateFormatter nesnesi.
 jsonDecoder: JSON verilerini çözmek için kullanılan bir JSONDecoder nesnesi.
 headers: API isteğine eklenen HTTP başlıklarını temsil eden bir sözlük.
 Message: Bir sohbet mesajını temsil eden bir yapı.
 Request: API isteği için kullanılan veri modelini temsil eden bir yapı.
 ErrorRootResponse: API hatalarını temsil eden bir yapı.
 CompletionResponse: Tamamlama API yanıtını temsil eden bir yapı.
 Ayrıca ChatGPTAPI sınıfı, aşağıdaki yöntemlere sahiptir:

 init: Sınıfın başlatıcı yöntemi. API anahtarı, dil modeli, sistem mesajı ve sıcaklık gibi parametreleri alır ve sınıfın özelliklerini ayarlar.
 generateMessages: Metin girişine göre bir mesaj listesi oluşturan özel bir yöntem.
 jsonBody: API isteği için JSON veri gövdesini oluşturan özel bir yöntem.
 appendToHistoryList: Kullanıcı ve asistan mesajlarını geçmişe ekleyen bir yardımcı yöntem.
 sendMessageStream: Metin tabanlı sohbeti asenkron olarak başlatan ve sonuçları bir akışta döndüren bir yöntem.
 sendMessage: Metin tabanlı sohbeti tamamlamak için kullanılan bir yöntem.
 deleteHistoryList: Geçmiş mesajları temizleyen bir yöntem.
 Kod aynı zamanda String sınıfına CustomNSError protokolünü uygulayan bir uzantı da içerir. Bu, hatalı durumlarda kullanıcıya hata mesajları sağlamak için kullanılır.
 */
