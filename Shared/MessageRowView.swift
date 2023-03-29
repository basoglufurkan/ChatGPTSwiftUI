//
//  MessageRowView.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 02/02/23.
//

import SwiftUI

struct MessageRowView: View {
    @Environment(\.colorScheme) private var colorScheme
    let message: MessageRow
    let retryCallback: (MessageRow) -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
               
                    Image(message.sendImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding(EdgeInsets(top: 0, leading:0, bottom: 30, trailing: 0))
                
                VStack(alignment: .leading, spacing: 4) {
                    if message.sendText.isEmpty == false {
                        Text(message.sendText)
                            .padding(EdgeInsets(top: 8, leading: 0, bottom: 20, trailing: 0))
                            .foregroundColor(Color.primary)
                            .clipShape(ChatBubble(isFromCurrentUser: true))
                    }
                    if message.responseText != nil {
                        Divider()
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                if let error = message.responseError {
                                    Text("Error: \(error)")
                                        .foregroundColor(.red)
                                } else {
                                    Text(message.responseText!)
                                        .foregroundColor(Color.primary)
                                        
                                        .clipShape(ChatBubble(isFromCurrentUser: false))
                                }
                                if message.isInteractingWithChatGPT {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .frame(maxWidth: .infinity, alignment: message.isInteractingWithChatGPT ? .trailing : .leading)
            .background(colorScheme == .light ? Color.white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray, lineWidth: 1))
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            
            HStack {
                            Spacer()
                            Button(action: {
                                UIPasteboard.general.string = message.sendText.isEmpty ? message.responseText ?? "" : message.responseText
                            }, label: {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(Color.gray)
                            })
                            .buttonStyle(BorderlessButtonStyle())
                            .padding(.trailing, 16)
                        }
        }
    }
}

struct ChatBubble: Shape {
    var isFromCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let cornerRadius: CGFloat = 0
        let arrowSize = CGSize(width: 8, height: 8)
        let arrowPosition: CGFloat = -20
        
        var path = Path()
        
        if isFromCurrentUser {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 180), clockwise: false)
            path.addLine(to: CGPoint(x: rect.maxX - arrowPosition - arrowSize.width, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - arrowPosition, y: rect.minY - arrowSize.height))
            path.addLine(to: CGPoint(x: rect.maxX - arrowPosition, y: rect.minY + cornerRadius))
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            path.closeSubpath()
        } else {
            path.move(to: CGPoint(x: rect.minX + arrowPosition, y: rect.minY + cornerRadius))
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 180), clockwise: false)
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX + arrowPosition + arrowSize.width, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + arrowPosition, y: rect.maxY - arrowSize.height))
            path.addLine(to: CGPoint(x: rect.minX + arrowPosition, y: rect.minY + cornerRadius))
            path.closeSubpath()
        }
        
        return path
    }
    
}

struct MessageRowView_Previews: PreviewProvider {
    
    static let message = MessageRow(
        isInteractingWithChatGPT: true, sendImage: "profile",
        sendText: "What is SwiftUI?",
        responseImage: "openai",
        responseText: "SwiftUI is a user interface framework that allows developers to design and develop user interfaces for iOS, macOS, watchOS, and tvOS applications using Swift, a programming language developed by Apple Inc.")
    
    static let message2 = MessageRow(
        isInteractingWithChatGPT: false, sendImage: "profile",
        sendText: "What is SwiftUI?",
        responseImage: "openai",
        responseText: "",
        responseError: "ChatGPT is currently not available")
        
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ScrollView {
                    MessageRowView(message: message, retryCallback: { messageRow in
                        
                    })
                    
                    MessageRowView(message: message2, retryCallback: { messageRow in
                        
                    })
                    
                }
                .frame(width: 400)
                .previewLayout(.sizeThatFits)
            }
        } else {
            ScrollView {
                MessageRowView(message: message, retryCallback: { messageRow in
                    
                })
                
                MessageRowView(message: message2, retryCallback: { messageRow in
                    
                })
                
            }
            .frame(width: 400)
            .previewLayout(.sizeThatFits)
        }
    }
}

/*
 This code is written in Swift and is a part of a larger project that is responsible for creating a chat interface that interacts with an OpenAI language model (ChatGPT). The specific code contains a SwiftUI view called MessageRowView which is responsible for displaying a single message row in the chat interface.

 The MessageRowView takes in a MessageRow object and displays the sendText, sendImage, responseText, and responseImage properties. If responseError is not nil, it is also displayed. If isInteractingWithChatGPT is true, a loading indicator is displayed next to the message.

 The body property of the MessageRowView is a VStack that displays the messageRow view with the sendText and sendImage, and if responseText is not nil, it displays another messageRow with the responseText and responseImage. A divider is also added between the send and response messageRows.

 The messageRow function is responsible for creating the UI for each message row. The UI for the messageRow function is determined based on the device the app is running on. On watchOS, the messageRow function uses a VStack to display the message, while on other devices, it uses a HStack. The messageRowContent function is called by messageRow and contains the actual UI for the message row.

 The AsyncImage is used to load an image asynchronously from a URL. If the URL starts with "http", AsyncImage is used to display the image, otherwise, a local image is displayed.

 The responseTextView function is used to display the response text on tvOS. It splits the text into multiple rows, each containing up to eight lines of text. The rowsFor function is used to split the text into multiple rows.
 */
