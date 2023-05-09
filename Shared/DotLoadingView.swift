//
//  DotLoadingView.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 02/02/23.
//

import SwiftUI

struct DotLoadingView: View {
    
    @State private var showCircle1 = false
    @State private var showCircle2 = false
    @State private var showCircle3 = false
    
    var body: some View {
        HStack {
            Circle()
                .opacity(showCircle1 ? 1 : 0)
            Circle()
                .opacity(showCircle2 ? 1 : 0)
            Circle()
                .opacity(showCircle3 ? 1 : 0)
        }
        .foregroundColor(.gray.opacity(0.5))
        .onAppear { performAnimation() }
    }
    
    func performAnimation() {
        let animation = Animation.easeInOut(duration: 0.4)
        withAnimation(animation) {
            self.showCircle1 = true
            self.showCircle3 = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(animation) {
                self.showCircle2 = true
                self.showCircle1 = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(animation) {
                self.showCircle2 = false
                self.showCircle3 = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.performAnimation()
        }
    }
}

struct DotLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        DotLoadingView()
    }
}

/*
 this code defines a DotLoadingView view in SwiftUI that displays three circles that appear and disappear in sequence, giving the appearance of a loading animation. The view uses @State variables to track whether each circle should be displayed, and starts the animation automatically when the view appears using the onAppear modifier.
 
 The performAnimation function is called repeatedly to perform the animation. It uses DispatchQueue.main.asyncAfter to schedule the changes to the showCircle variables with a delay, so that each circle appears and disappears in sequence.
 
 The view is previewed using the DotLoadingView_Previews struct, which simply displays the DotLoadingView with default settings.
 */
