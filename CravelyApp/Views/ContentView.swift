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
        case content, history, settings
    }
    @State private var selectedTab: Tab = .content
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Screen content area
            ZStack {
                switch selectedTab {
                case .content:
                    HomeView()
                case .history:
                    HistoryView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 10)
            .padding(.top, 10)
            .modelContainer(for: Tap.self)
            // Pinned Tab Bar
            tabBar
                .padding(.horizontal, 20)
                .background(Color(uiColor: .systemBackground))
        }
        // Prevents keyboard or safe-area dynamic shifts from moving the bar
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private var tabBar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.primary)
                .frame(height: 1)
                .opacity(0.2)
                .padding(.bottom, 10)

            HStack(spacing: 0) {
                tabItem(icon: "inset.filled.circle", label: "Home", tab: .content)
                tabItem(icon: "text.justify", label: "History", tab: .history)
                tabItem(icon: "gear", label: "Settings", tab: .settings)
            }
        }
        .padding(.top, 8)
    }

    private func tabItem(icon: String, label: String, tab: Tab) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
            Text(label)
                .font(.system(size: 12))
        }
        .frame(maxWidth: .infinity)
        .opacity(selectedTab == tab ? 1.0 : 0.5)
        .foregroundStyle(selectedTab == tab ? Color.green : Color.primary)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedTab = tab
        }
    }
}

#Preview {
    ContentView()
        .environment(AppModel())

}
