//
//  HomeView.swift
//  CravelyApp
//
//  Created by ayman moh on 28/07/2026.
//

import SwiftUI

// MARK: - CravingViewModel

/// Holds the home screen's live state and the logic for logging a
/// resisted craving. Swap the storage in `logResist()` for your
/// SwiftData model when the persistence layer is wired in — the
/// view itself won't need to change.
@Observable
final class CravingViewModel {

    var streakDays: Int
    var totalSaved: Double
    var resistedCount: Int
    var savedToday: Double
    var cigarettePrice: Double
    var cigaretteBrand: String

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

    func logResist() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        resistedCount += 1
        totalSaved += cigarettePrice
        savedToday += cigarettePrice
    }
}


struct HomeView: View {
    @State private var viewModel = CravingViewModel()
    private let greeting = "Good Morning Sun"

    var body: some View {
        VStack {
            headerView
            greetingRow
            statsCard
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

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
                .background(RoundedRectangle(cornerRadius: 20).opacity(0.1))
                .accessibilityLabel("\(viewModel.streakDays) day streak")
        }
        .padding(.bottom, 20)
    }

    private var statsCard: some View {
        VStack {
            savingsHeader
            savingsAmount
            cigaretteInfoLabel
            divider
            statsRow
            divider
            resistButtonSection
        }
    }

    private var savingsHeader: some View {
        HStack {
            Text("Total Saved")
                .font(.system(size: 14))
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var savingsAmount: some View {
        HStack(alignment: .top, spacing: 2) {
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

    private var divider: some View {
        HStack {
            Rectangle()
                .fill(Color.primary)
                .frame(height: 1)
                .opacity(0.2)
        }
        .padding(.vertical, 24)
    }

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

    private var statDivider: some View {
        Rectangle()
            .fill(Color.primary)
            .frame(width: 1, height: 62)
            .opacity(0.2)
    }

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
            Circle()
                .stroke(Color.primary, lineWidth: 0.5)
                .frame(width: 220, height: 220)
                .opacity(0.2)
            Circle()
                .frame(width: 180, height: 180)
                .foregroundStyle(Color(red: 22 / 255, green: 22 / 255, blue: 22 / 255))
            VStack(spacing: 15) {
                Text("🚬")
                    .font(.system(size: 42, weight: .bold))
                Text("I crave one")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    HomeView()
}
