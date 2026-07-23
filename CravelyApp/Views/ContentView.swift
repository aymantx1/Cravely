//
//  ContentView.swift
//  CravelyApp
//
//  Created by ayman moh on 22/07/2026.
//

import SwiftUI

// MARK: - CravingViewModel

/// Holds the home screen's live state and the logic for logging a
/// resisted craving. Swap the storage in `logResist()` for your
/// SwiftData model when the persistence layer is wired in — the
/// view itself won't need to change.
@Observable
final class CravingViewModel {

    // MARK: Published State

    var streakDays: Int
    var totalSaved: Double
    var resistedCount: Int
    var savedToday: Double
    var cigarettePrice: Double
    var cigaretteBrand: String

    // MARK: Init

    init(
        streakDays: Int = 14,
        totalSaved: Double = 20,
        resistedCount: Int = 200,
        savedToday: Double = 0,
        cigarettePrice: Double = 20,
        cigaretteBrand: String = "Malboro Reds"
    ) {
        self.streakDays = streakDays
        self.totalSaved = totalSaved
        self.resistedCount = resistedCount
        self.savedToday = savedToday
        self.cigarettePrice = cigarettePrice
        self.cigaretteBrand = cigaretteBrand
    }

    // MARK: Actions

    /// Called when the user taps "I crave one" and resists.
    /// Fires haptic feedback and updates the running totals.
    /// TODO: persist this event (e.g. insert a `Craving` model into
    /// SwiftData's modelContext) instead of only mutating in-memory state.
    func logResist() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        resistedCount += 1
        totalSaved += cigarettePrice
        savedToday += cigarettePrice
    }
}

// MARK: - ContentView

/// Main home screen: shows the user's streak, total money saved,
/// quick stats, and the "I crave one" resist button.
struct ContentView: View {

    // MARK: Properties
    enum Tab {
        case content, history, settings
    }
    @State private var selectedTab: Tab = .content
    
    @State private var viewModel = CravingViewModel()
    private let greeting = "Good Morning Sun"

    // MARK: Body

    var body: some View {
        VStack {
            if selectedTab == .content {
                headerView
                greetingRow
                statsCard
            }
            
            switch selectedTab {
                case .content: EmptyView() // already shown above
                case .history: HistoryView()
                case .settings: SettingsView()
            }
            
            Spacer()
            tabBar
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    // MARK: - Header ("Cravely  Home")

    private var headerView: some View {
        HStack {
            Text("Cravely")
                .font(.system(size: 28))
                .fontWeight(.heavy)

            Text("Home")
                .font(.system(size: 28))
                .bold()
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 30)
    }

    // MARK: - Greeting + Streak Badge

    private var greetingRow: some View {
        HStack {
            Text(greeting)
                .font(.system(size: 14))
                .opacity(0.5)

            Spacer()

            Text("🔥 \(viewModel.streakDays)d")
                .bold()
                .font(.system(size: 14))
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .opacity(0.1)
                )
                .accessibilityLabel("\(viewModel.streakDays) day streak")
        }
        .padding(.bottom, 20)
    }

    // MARK: - Main Card (savings, stats, resist button)

    private var statsCard: some View {
        VStack {
            savingsHeader
            savingsAmount
            cigaretteInfoLabel
            divider
            statsRow
            divider
            resistButtonSection
            Spacer()
        }
    }

    // MARK: Savings Section

    private var savingsHeader: some View {
        HStack {
            Text("Total Saved")
                .font(.system(size: 14))
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var savingsAmount: some View {
        // Using an HStack with .alignment(.firstTextBaseline) instead of a
        // manual baselineOffset hack keeps the "$" sitting on the same
        // baseline as the big number, and adapts correctly to Dynamic Type.
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            Text("$")
                .font(.system(size: 36))
                .opacity(0.5)
                .fontWeight(.light)

            Text(viewModel.totalSaved, format: .number.precision(.fractionLength(2)))
                .font(.system(size: 72))
                .fontWeight(.heavy)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Total saved: $\(viewModel.totalSaved.formatted(.number.precision(.fractionLength(2))))")
    }

    private var cigaretteInfoLabel: some View {
        HStack {
            Text("\(viewModel.cigaretteBrand)  •  $\(viewModel.cigarettePrice.formatted()) per unit")
                .font(.system(size: 14))
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: Divider

    /// Thin horizontal rule used to separate sections of the card.
    /// Uses an adaptive color so it stays visible in both light and dark mode.
    private var divider: some View {
        HStack {
            Rectangle()
                .fill(Color.primary)
                .frame(height: 1)
                .opacity(0.2)
        }
        .padding(.vertical, 24)
    }

    // MARK: Stats Row (resisted / days clean / saved today)

    private var statsRow: some View {
        HStack {
            statColumn(value: "\(viewModel.resistedCount)", label: "Resisted")

            statDivider

            statColumn(value: "\(viewModel.streakDays)", label: "Days clean")

            statDivider

            statColumn(
                value: viewModel.savedToday.formatted(.number.precision(.fractionLength(0))),
                label: "Saved today"
            )
        }
    }

    /// One column of the stats row (a number over a caption).
    private func statColumn(value: String, label: String) -> some View {
        VStack {
            Text(value)
                .font(.system(size: 22))
                .fontWeight(.semibold)

            Text(label)
                .font(.system(size: 12))
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }

    /// Vertical hairline separating stat columns. Adaptive for dark mode.
    private var statDivider: some View {
        Rectangle()
            .fill(Color.primary)
            .frame(width: 1, height: 62)
            .opacity(0.2)
    }

    // MARK: - "I Crave One" Resist Button

    private var resistButtonSection: some View {
        VStack(alignment: .center, spacing: 20) {
            Button {
                viewModel.logResist()
            } label: {
                resistButtonLabel
            }
            .buttonStyle(.plain)
            .accessibilityLabel("I crave one")
            .accessibilityHint("Log that you resisted a craving and save $\(viewModel.cigarettePrice.formatted())")

            Text("Tap to resist & save $\(viewModel.cigarettePrice.formatted())")
                .font(.system(size: 14))
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var resistButtonLabel: some View {
        ZStack {
            // Outer ring — adaptive color instead of hardcoded .white so
            // it stays visible in light mode too.
            Circle()
                .stroke(Color.primary, lineWidth: 0.5)
                .frame(width: 220, height: 220)
                .opacity(0.2)

            // Inner filled circle. This is an intentional near-black
            // "button" color regardless of light/dark mode, so it's left
            // as a fixed color — only the stroke above was actually
            // mode-blind.
            Circle()
                .frame(width: 180, height: 180)
                .foregroundStyle(
                    Color(red: 22 / 255, green: 22 / 255, blue: 22 / 255)
                )

            // Icon + label
            VStack(spacing: 15) {
                Text("🚬")
                    .font(.system(size: 42, weight: .bold))

                Text("I crave one")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
    }
    private var tabBar: some View {
        VStack {
            HStack {
                Rectangle()
                    .fill(Color.primary)
                    .frame(height: 1)
                    .opacity(0.2)
            }
            .padding(.vertical, 10)
            
            HStack {
                tabItem(icon: "inset.filled.circle", label: "Home", tab: .content)
                    .padding(.horizontal, 24)
                Spacer()
                tabItem(icon: "text.justify", label: "History", tab: .history)
                Spacer()
                tabItem(icon: "gear", label: "Settings", tab: .settings)
                    .padding(.horizontal, 24)
            }
        }
    }

    private func tabItem(icon: String, label: String, tab: Tab) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
            Text(label)
                .font(.system(size: 12))
        }
        .opacity(selectedTab == tab ? 1.0 : 0.5)
        .foregroundStyle(selectedTab == tab ? Color.green : Color.primary)
        .onTapGesture {
            selectedTab = tab
        }
    }
    
}

// MARK: - Preview

#Preview {
    ContentView()
}
