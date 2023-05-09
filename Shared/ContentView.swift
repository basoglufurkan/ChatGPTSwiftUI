//
//  ContentView.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 01/02/23.
//

import SwiftUI
import AVKit
import StoreKit

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: ViewModel
    @FocusState var isTextFieldFocused: Bool
    let localizedText: LocalizedStringKey = "localizedText"
    @State var isPaywallPresented = false
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            chatListView
                .navigationTitle("ChatGenius")
            
        }
        .navigationViewStyle(.stack)
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        
                        ForEach(vm.messages) { message in
                            MessageRowView(message: message) { message in
                                Task { @MainActor in
                                    await vm.retry(message: message)
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        isTextFieldFocused = false
                    }
                }
#if os(iOS) || os(macOS)
                Divider()
                bottomView(image: "profile", proxy: proxy)
                Spacer()
#endif
            }
            .onChange(of: vm.messages.last?.responseText) { _ in  scrollToBottom(proxy: proxy)
            }
        }
        .background(colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
        .sheet(isPresented: $isPaywallPresented, onDismiss: nil) {
            
            Paywall(isPaywallPresented: $isPaywallPresented)
        }
        
    }
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        HStack(alignment: .top, spacing: 8) {
            if image.hasPrefix("http"), let url = URL(string: image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 30, height: 30)
                } placeholder: {
                    ProgressView()
                }
                
            } else {
                Image(image)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            if #available(iOS 16.0, *) {
                TextField(localizedText, text: $vm.inputMessage, axis: .vertical)
#if os(iOS) || os(macOS)
                    .textFieldStyle(.roundedBorder)
#endif
                    .focused($isTextFieldFocused)
                    .disabled(vm.isInteractingWithChatGPT)
            } else {
                TextField(localizedText, text: $vm.inputMessage)
#if os(iOS) || os(macOS)
                    .textFieldStyle(.roundedBorder)
#endif
                    .focused($isTextFieldFocused)
                    .disabled(vm.isInteractingWithChatGPT)
            }
            
            if vm.isInteractingWithChatGPT {
                DotLoadingView().frame(width: 60, height: 30)
            } else {
                Button {
                    
                    if vm.messageCounter < 1 {
                        Task {
                            isTextFieldFocused = false
                            scrollToBottom(proxy: proxy)
                            await vm.sendTapped()
                        }
                    } else {
                        if userViewModel.isSubscriptionActive {
                            Task { @MainActor in
                                isTextFieldFocused = false
                                scrollToBottom(proxy: proxy)
                                await vm.sendTapped()
                            }
                        }else {
                            isPaywallPresented = true
                        }
                    }
                    
                    switch vm.messageCounter {
                    case 20:
                        //                        requestReview()
                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    case 50:
                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    case 200:
                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    case 500:
                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                        
                    default:
                        break
                    }
                    
                    
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .rotationEffect(.degrees(45))
                        .font(.system(size: 30))
                    
                }
#if os(macOS)
                .buttonStyle(.borderless)
                .keyboardShortcut(.defaultAction)
                .foregroundColor(.accentColor)
#endif
                .disabled(vm.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ContentView(vm: ViewModel(api: ChatGPTAPI(apiKey: "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")))
            }
        } else {
            ScrollView {
                ContentView(vm: ViewModel(api: ChatGPTAPI(apiKey: "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")))
            }
        }
    }
}
