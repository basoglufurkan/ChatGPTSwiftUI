//
//  XCAChatGPTApp.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 01/02/23.
//

import SwiftUI
import RevenueCat
import FirebaseCore

//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//}

@main
struct XCAChatGPTApp: App {
    
    @StateObject var vm = ViewModel(api: ChatGPTAPI(apiKey: "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"))
    @StateObject var userViewModel = UserViewModel()
    @State private var showLaunchView: Bool = true
    
    init() {
        FirebaseApp.configure()
        Purchases.logLevel = .debug
        Purchases.configure(
            with: Configuration.Builder(withAPIKey: "appl_cbNcPHgHiKKFSGXpPtEXfvtwlqR")
                .with(usesStoreKit2IfAvailable: true)
                .build()
        )
        
        //        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_cbNcPHgHiKKFSGXpPtEXfvtwlqR")
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
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
    
    
}
