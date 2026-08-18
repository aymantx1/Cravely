//
//  CravelyAppApp.swift
//  CravelyApp
//

import SwiftUI
import SwiftData

@main
struct CravelyAppApp: App {
    @State private var settingsViewModel = SettingsViewModel()
    @State private var notificationManager = NotificationManager.shared
    @State private var isLoading: Bool = true
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if hasCompletedOnboarding {
                    ContentView()
                        .environment(settingsViewModel)
                        .environment(notificationManager)
                        .modelContainer(for: Tap.self)
                        .opacity(isLoading ? 0 : 1)
                } else {
                    OnboardingFlowView()
                        .environment(settingsViewModel)
                        .environment(notificationManager)
                        .modelContainer(for: Tap.self)
                        .opacity(isLoading ? 0 : 1)
                }

                if isLoading {
                    LaunchScreenView()
                        .transition(.opacity.animation(.easeInOut(duration: 0.35)))
                }
            }
            .task {
                try? await Task.sleep(for: .seconds(1.2))
                
                withAnimation(.easeOut(duration: 0.35)) {
                    isLoading = false
                }
            }
        }
    }
}

