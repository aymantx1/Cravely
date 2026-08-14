//
//  ContentView.swift
//  CravelyApp
//
//  Created by ayman moh on 22/07/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    enum Tab {
        case home, history, settings
    }
    
    @State private var selectedTab: Tab = .home
    @Environment(SettingsViewModel.self) private var settings
    
    var body: some View {
        VStack(spacing: 0) {
            // Screen Content Area
            ZStack {
                switch selectedTab {
                case .home:
                    HomeView()
                case .history:
                    HistoryView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Pinned Tab Bar
            tabBar
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    // MARK: - Custom Tab Bar View
    
    private var tabBar: some View {
        VStack(spacing: 0) {
            // Divider line
            Rectangle()
                .fill(Color.white)
                .frame(height: 1)
                .opacity(0.15)
            
            HStack(spacing: 0) {
                tabItem(icon: "inset.filled.circle", label: "Home", tab: .home)
                tabItem(icon: "text.justify", label: "History", tab: .history)
                tabItem(icon: "gearshape.fill", label: "Settings", tab: .settings)
            }
            .padding(.top, 12)
            .padding(.bottom, 8)
        }
        .background(Color(red: 12/255, green: 12/255, blue: 12/255).ignoresSafeArea(edges: .bottom))
    }

    private func tabItem(icon: String, label: String, tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.system(size: 11, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(selectedTab == tab ? Color.green : Color.white.opacity(0.4))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environment(SettingsViewModel())
        .modelContainer(for: Tap.self, inMemory: true)
}
