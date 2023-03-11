//
//  ViewModel.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 02/02/23.
//

import Foundation
import SwiftUI
import AVKit
import AVFoundation

class ViewModel: ObservableObject {
    
    @Published var isInteractingWithChatGPT = false
    @Published var messages: [MessageRow] = []
    @Published var inputMessage: String = ""
    @AppStorage("messageCounter") var messageCounter = 0
    private var synthesizer: AVSpeechSynthesizer?
    
    private let api: ChatGPTAPI
    
    init(api: ChatGPTAPI, enableSpeech: Bool = false) {
        self.api = api
        if enableSpeech {
            synthesizer = .init()
        }
    }
    
    @MainActor
    func sendTapped() async {
        let text = inputMessage
        inputMessage = ""
        await send(text: text)
        messageCounter += 1
    }
    
    @MainActor
    func clearMessages() {
        stopSpeaking()
        api.deleteHistoryList()
        withAnimation { [weak self] in
            self?.messages = []
        }
    }
    
    @MainActor
    func retry(message: MessageRow) async {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else {
            return
        }
        self.messages.remove(at: index)
        await send(text: message.sendText)
    }
    
    @MainActor
    private func send(text: String) async {
        isInteractingWithChatGPT = true
        var streamText = ""
        var messageRow = MessageRow(
            isInteractingWithChatGPT: true,
            sendImage: "profile",
            sendText: text,
            responseImage: "openai",
            responseText: streamText,
            responseError: nil)
        
        self.messages.append(messageRow)
        
        do {
            let stream = try await api.sendMessageStream(text: text)
            for try await text in stream {
                streamText += text
                messageRow.responseText = streamText.trimmingCharacters(in: .whitespacesAndNewlines)
                self.messages[self.messages.count - 1] = messageRow
            }
        } catch {
            messageRow.responseError = error.localizedDescription
        }
        
        messageRow.isInteractingWithChatGPT = false
        self.messages[self.messages.count - 1] = messageRow
        isInteractingWithChatGPT = false
        speakLastResponse()
        
    }
    
    func speakLastResponse() {
        guard let synthesizer, let responseText = self.messages.last?.responseText, !responseText.isEmpty else {
            return
        }
        stopSpeaking()
        let utterance = AVSpeechUtterance(string: responseText)
        utterance.voice = .init(language: "en-US")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        synthesizer.speak(utterance )
    }
    
    func stopSpeaking() {
        synthesizer?.stopSpeaking(at: .immediate)
    }
    
}
/*
 This is a Swift code that defines a ViewModel class that manages the interaction with an API to send messages and receive responses. The class has several published properties that can be observed by the View layer to update the UI, such as the list of messages, the input message, and a boolean flag that indicates if the user is currently interacting with the ChatGPT.

 The ViewModel class also implements several methods, such as sendTapped to send a message, clearMessages to delete the history list, and retry to resend a failed message.

 Additionally, the ViewModel has two methods related to speech synthesis: speakLastResponse to read aloud the last received response, and stopSpeaking to stop the speech synthesis.

 The ViewModel receives an instance of a ChatGPTAPI when it's created, which is used to send and receive messages from the API. It also has a messageCounter property that's stored in the App Storage.

 The ViewModel class is defined as an ObservableObject, which means that it can publish changes to its properties, and the View layer can observe these changes and update the UI accordingly.
 */
