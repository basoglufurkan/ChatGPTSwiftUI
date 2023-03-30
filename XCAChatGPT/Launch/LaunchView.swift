//
//  LaunchView.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 5.02.2022.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "C H A T T Y G P T".map { String($0) }
    @State private var showLoadingText: Bool = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        
        GeometryReader { geometry in
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            
            Image("back")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            Image("openai")
                .resizable()
                .frame(width: 350, height: 350)
            
            ZStack {
                if showLoadingText {
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.launch.launchBackground)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
                
            }
            .offset(y: 120)
            
        }
        .onAppear {
            showLoadingText.toggle()
        }
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()) {
                
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        })
    }
    
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}

