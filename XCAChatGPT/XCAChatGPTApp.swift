//
//  XCAChatGPTApp.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 01/02/23.
//

import SwiftUI
import RevenueCat
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct XCAChatGPTApp: App {
    
    @StateObject var vm = ViewModel(api: ChatGPTAPI(apiKey: "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"))
    @StateObject var userViewModel = UserViewModel()
    @State private var showLaunchView: Bool = true

  
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            /*
             ContentView(vm: vm)
                 .toolbar {
                     ToolbarItem {
                         Button("Clear") {
                             vm.clearMessages()
                         }
                         .disabled(vm.isInteractingWithChatGPT)
                     }
                 }
                 .environmentObject(userViewModel)
             */
            ZStack {
//                NavigationView {
                    ContentView(vm: vm)
                        .toolbar {
                            ToolbarItem {
                                Button("Clear") {
                                    vm.clearMessages()
                                }
                                .disabled(vm.isInteractingWithChatGPT)
                            }
                        }
                        .environmentObject(userViewModel)
//                }
//                .navigationViewStyle(StackNavigationViewStyle())
                

                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
            
                
            
        }
    }
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_cbNcPHgHiKKFSGXpPtEXfvtwlqR")
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        UITableView.appearance().backgroundColor = UIColor.clear
    }
}
