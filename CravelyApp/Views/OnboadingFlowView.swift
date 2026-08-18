import SwiftUI

// MARK: - Navigation Types

enum OnboardingStep: Hashable {
    case smokeType
    case brandSelection
}

// MARK: - Main Flow Container View

struct OnboardingFlowView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            NotificationPermissionView(onContinue: {
                navigationPath.append(OnboardingStep.smokeType)
            })
            .navigationDestination(for: OnboardingStep.self) { step in
                switch step {
                case .smokeType:
                    SmokeTypeView(onContinue: {
                        navigationPath.append(OnboardingStep.brandSelection)
                    })
                case .brandSelection:
                    BrandSelectionView(onFinish: {
                        hasCompletedOnboarding = true
                    })
                }
            }
        }
        .tint(.green)
    }
}

// MARK: - Step 1: Notification Permission View

struct NotificationPermissionView: View {
    @Environment(NotificationManager.self) private var notificationManager
    
    var onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()

            Text("🔔")
                .font(.system(size: 40))
                .padding(.bottom, 24)

            Text("Enable Notifications")
                .font(.system(size: 32, weight: .heavy))
                .foregroundStyle(.white)
                .padding(.bottom, 12)

            Text("Get daily check-in reminders at 8:00 PM to log cravings and keep your streak going.")
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.5))
                .padding(.bottom, 28)

            Button {
                handleEnableNotifications()
            } label: {
                Text("Enable Notifications")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.green.opacity(0.8)))
            }
            .buttonStyle(.plain)
            .padding(.bottom, 12)

            Button {
                onContinue()
            } label: {
                Text("Maybe Later")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.black.ignoresSafeArea())
        .toolbarRole(.editor)
    }

    private func handleEnableNotifications() {
        Task {
            let granted = await notificationManager.requestAuthorization()
            if granted {
                await notificationManager.schedule8PMDailyReminder()
            }
            await MainActor.run {
                onContinue()
            }
        }
    }
}

// MARK: - Step 2: Smoke Type Selection View

struct SmokeTypeView: View {
    @Environment(SettingsViewModel.self) private var settings
    var onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()

            Text("🚬")
                .font(.system(size: 40))
                .padding(.bottom, 24)

            Text("What do you smoke?")
                .font(.system(size: 32, weight: .heavy))
                .foregroundStyle(.white)
                .padding(.bottom, 12)

            Text("No judgment. We just need to know what to track.")
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.5))
                .padding(.bottom, 28)

            HStack(spacing: 12) {
                ForEach(SettingsViewModel.HabitType.allCases) { type in
                    optionCard(type)
                }
            }
            .padding(.bottom, 28)

            Button {
                onContinue()
            } label: {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.green.opacity(0.8)))
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.black.ignoresSafeArea())
        .toolbarRole(.editor)
    }

    private func optionCard(_ type: SettingsViewModel.HabitType) -> some View {
        let isSelected = settings.habitType == type
        return Button {
            settings.habitType = type
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                Text(type.emoji)
                    .font(.system(size: 26))
                Text(type.rawValue == "Cigs" ? "Cigarettes" : type.rawValue)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.green : .white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.green.opacity(0.18) : Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.green : Color.white.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Step 3: Brand Selection View

struct BrandSelectionView: View {
    @Environment(SettingsViewModel.self) private var settings

    @State private var customPriceText: String = ""
    @State private var usingCustomPrice: Bool = false
    @FocusState private var customFieldFocused: Bool

    var onFinish: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("🏷️")
                    .font(.system(size: 34))
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                Text("Your usual?")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundStyle(.white)
                    .padding(.bottom, 8)

                Text("Pick your brand — we'll track savings per unit.")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.bottom, 20)

                VStack(spacing: 0) {
                    ForEach(Array(rowNames.enumerated()), id: \.offset) { index, name in
                        brandRow(name: name, price: price(for: name))
                        if index < rowNames.count - 1 {
                            Rectangle()
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 1)
                        }
                    }
                }
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.05)))
                .padding(.bottom, 16)

                customPriceField
                    .padding(.bottom, 24)

                Button {
                    finish()
                } label: {
                    Text("Start Saving")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(RoundedRectangle(cornerRadius: 16).fill(canFinish ? Color.green : Color.green.opacity(0.3)))
                }
                .buttonStyle(.plain)
                .disabled(!canFinish)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.black.ignoresSafeArea())
        .toolbarRole(.editor)
    }

    private var rowNames: [String] {
        settings.habitType == .cigarettes
            ? SettingsViewModel.CigaretteBrand.allCases.map(\.rawValue)
            : SettingsViewModel.CannabisProduct.allCases.map(\.rawValue)
    }

    private func price(for name: String) -> Double {
        if settings.habitType == .cigarettes {
            return SettingsViewModel.CigaretteBrand(rawValue: name)?.defaultPrice ?? 0
        } else {
            return SettingsViewModel.CannabisProduct(rawValue: name)?.defaultPrice ?? 0
        }
    }

    private var canFinish: Bool {
        !settings.selectedBrand.isEmpty && settings.packPrice > 0
    }

    private func brandRow(name: String, price: Double) -> some View {
        let isSelected = !usingCustomPrice && settings.selectedBrand == name
        return Button {
            usingCustomPrice = false
            customPriceText = ""
            customFieldFocused = false
            settings.selectBrandOrProduct(name)
        } label: {
            HStack {
                Text(name)
                    .font(.system(size: 16))
                    .foregroundStyle(isSelected ? .green : .white)
                Spacer()
                Text(price, format: .currency(code: "USD"))
                    .font(.system(size: 16))
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(isSelected ? Color.green.opacity(0.18) : Color.clear)
        }
        .buttonStyle(.plain)
    }

    private var customPriceField: some View {
        HStack {
            Text("Custom price")
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.4))
            Spacer()
            Text("$")
                .foregroundStyle(.white.opacity(0.5))
            TextField("0.00", text: $customPriceText)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.white)
                .focused($customFieldFocused)
                .frame(width: 70)
                .onChange(of: customPriceText) { _, newValue in
                    if let value = Double(newValue), value > 0 {
                        usingCustomPrice = true
                        settings.selectedBrand = "Custom"
                        settings.packPrice = value
                    }
                }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 14).fill(usingCustomPrice ? Color.green.opacity(0.18) : Color.white.opacity(0.05)))
    }

    private func finish() {
        customFieldFocused = false
        onFinish()
    }
}

// MARK: - Preview

#Preview {
    OnboardingFlowView()
        .environment(SettingsViewModel())
        .environment(NotificationManager.shared)
}
