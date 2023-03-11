//
//  MessageRow.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 02/02/23.
//

import SwiftUI

struct MessageRow: Identifiable {
    
    let id = UUID()
    
    var isInteractingWithChatGPT: Bool
    
    let sendImage: String
    let sendText: String
    
    let responseImage: String
    var responseText: String?
    
    var responseError: String?
    
}

/*
 This is a simple struct that defines the properties of a single message row in the chat interface. It conforms to the Identifiable protocol, which requires a unique id property. The struct has the following properties:

 isInteractingWithChatGPT: A boolean value that indicates whether the message is being sent to or received from ChatGPT.
 sendImage: A string that specifies the name of the image to be displayed for the message sender.
 sendText: A string that represents the text content of the message being sent.
 responseImage: A string that specifies the name of the image to be displayed for the ChatGPT response.
 responseText: An optional string that represents the text content of the ChatGPT response.
 responseError: An optional string that represents any error that occurred while sending or receiving the message.
 */
