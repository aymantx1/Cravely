//
//  CravelyAppApp.swift
//  CravelyApp
//

import SwiftUI
import SwiftData

@main
struct CravelyAppApp: App {
    @State private var settingsViewModel = SettingsViewModel()
    @State private var isLoading: Bool = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(settingsViewModel)
                    .modelContainer(for: Tap.self)
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    LaunchScreenView()
                        .transition(.opacity.animation(.easeInOut(duration: 0.35)))
                }
            }
            .task {
                // Adjust duration as needed
                try? await Task.sleep(for: .seconds(1.2))
                
                withAnimation(.easeOut(duration: 0.35)) {
                    isLoading = false
                }
            }
        }
    }
}
