//
//  HomeView.swift
//  CravelyApp
//
//  Created by ayman moh on 28/07/2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    // MARK: - Dependencies
    @Environment(SettingsViewModel.self) private var settings
    @Environment(\.modelContext) private var modelContext
    
    // ViewModel state
    @State private var viewModel = HomeViewModel()
    
    // Auto-updating query for SwiftData logs
    @Query(sort: \Tap.time, order: .reverse) private var taps: [Tap]
    
    // Smoke animation state
    @State private var smokeParticles: [SmokeParticle] = []
    
    // Dynamic greeting calculation
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good Morning ☕"
        case 12..<17: return "Good Afternoon 🌞"
        case 17..<22: return "Good Evening 🌇"
        default:      return "Good Night 🌙 "
        }
    }

    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerView
                greetingRow
                statsCard
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            viewModel.updateWidgetSnapshot(from: taps, settings: settings)
        }
        .onChange(of: taps.count) {
            viewModel.updateWidgetSnapshot(from: taps, settings: settings)
        }
    }

    // MARK: - Header Views
    
    private var headerView: some View {
        HStack {
            Text("Cravely")
                .font(.system(size: 28))
                .fontWeight(.heavy)
                .foregroundStyle(.white)
            Text("Home")
                .font(.system(size: 28))
                .bold()
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 20)
    }

    private var greetingRow: some View {
        HStack {
            Text(greeting)
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.5))
            Spacer()
            Text("🔥 \(viewModel.currentStreak(from: taps))")
                .bold()
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.1)))
        }
        .padding(.bottom, 20)
    }

    // MARK: - Stats Card
    
    private var statsCard: some View {
        VStack(spacing: 0) {
            savingsHeader
            savingsAmount
            itemInfoLabel
            
            standardDivider
            
            statsRow
            
            tightDivider
            
            resistButtonSection
        }
    }

    private var savingsHeader: some View {
        HStack {
            Text("Total Saved")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var savingsAmount: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("$")
                .font(.system(size: 36, weight: .light))
                .foregroundStyle(.white.opacity(0.5))
            Text(viewModel.allTimeTotalCost(from: taps), format: .number.precision(.fractionLength(2)))
                .font(.system(size: 64, weight: .heavy))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var itemInfoLabel: some View {
        HStack {
            Text("\(settings.selectedBrand)  •  $\(settings.unitPrice, specifier: "%.2f") per use")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var standardDivider: some View {
        Rectangle()
            .fill(Color.white)
            .frame(height: 1)
            .opacity(0.15)
            .padding(.vertical, 20)
    }

    private var tightDivider: some View {
        Rectangle()
            .fill(Color.white)
            .frame(height: 1)
            .opacity(0.15)
            .padding(.top, 12)
            .padding(.bottom, 8)
    }

    private var statsRow: some View {
        HStack {
            statColumn(value: "\(taps.count)", label: "Resisted")
            statDivider
            statColumn(value: viewModel.lastCraveText(from: taps), label: "Last crave")
            statDivider
            statColumn(
                value: String(format: "$%.2f", viewModel.averageDailySave(from: taps)),
                label: "Avg daily save"
            )
        }
    }

    private func statColumn(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }

    private var statDivider: some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: 1, height: 35)
            .opacity(0.15)
    }

    // MARK: - Action Button
    
    private var resistButtonSection: some View {
        VStack(alignment: .center) {
            Button {
                viewModel.recordTap(context: modelContext, settings: settings)
                triggerSmokeEffect()
            } label: {
                resistButtonLabel
            }
            .sensoryFeedback(.impact(weight: .medium, intensity: 1.0), trigger: taps.count)
            .buttonStyle(.plain)
            .accessibilityLabel("I crave one")
            .accessibilityHint("Log that you resisted a craving and save $\(String(format: "%.2f", settings.unitPrice))")

            Text("Tap to resist & save $\(settings.unitPrice, specifier: "%.2f")")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.5))
        }
    }

    private var resistButtonLabel: some View {
        ZStack {
            // Smoke particle overlay - allowsHitTesting set to false to prevent blocking touches
            SmokeEffectView(particles: smokeParticles)
                .frame(width: 300, height: 300)
                .allowsHitTesting(false)

            Circle()
                .stroke(Color.white, lineWidth: 0.5)
                .frame(width: 200, height: 200)
                .opacity(0.2)
            Circle()
                .frame(width: 165, height: 165)
                .foregroundStyle(Color(red: 22 / 255, green: 22 / 255, blue: 22 / 255))
            VStack(spacing: 10) {
                Text(settings.habitType == .cigarettes ? "🚬" : "🌿")
                    .font(.system(size: 38))
                Text("I crave one")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
    }

    private func triggerSmokeEffect() {
        let newParticles = (0..<12).map { _ in
            SmokeParticle(
                id: UUID(),
                x: Double.random(in: -30...30),
                y: Double.random(in: -20...0),
                scale: Double.random(in: 0.5...1.2),
                opacity: 0.6,
                offsetY: 0
            )
        }
        smokeParticles = newParticles

        withAnimation(.easeOut(duration: 1.2)) {
            smokeParticles = smokeParticles.map { particle in
                var updated = particle
                updated.offsetY -= Double.random(in: 60...110)
                updated.opacity = 0
                updated.scale *= 1.8
                return updated
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            smokeParticles.removeAll()
        }
    }
}

// MARK: - Smoke Effect Components

struct SmokeParticle: Identifiable {
    let id: UUID
    var x: Double
    var y: Double
    var scale: Double
    var opacity: Double
    var offsetY: Double
}

struct SmokeEffectView: View {
    var particles: [SmokeParticle]

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(Color.white.opacity(particle.opacity))
                    .frame(width: 35, height: 35)
                    .blur(radius: 12)
                    .scaleEffect(particle.scale)
                    .offset(x: particle.x, y: particle.y + particle.offsetY)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView()
        .environment(SettingsViewModel())
}
