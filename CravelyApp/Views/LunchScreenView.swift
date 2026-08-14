//
//  LunchScreenView.swift
//  CravelyApp
//
//  Created by ayman moh on 14/08/2026.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            Image("CravelyLogo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 280)
                .scaleEffect(isAnimating ? 1 : 0.6)
                .opacity(isAnimating ? 1 : 0)
                .onAppear {
                    withAnimation(
                        .easeOut(duration: 1.2)
                    ) {
                        isAnimating = true
                    }
                }
        }
    }
}

#Preview {
    LaunchScreenView()
}
