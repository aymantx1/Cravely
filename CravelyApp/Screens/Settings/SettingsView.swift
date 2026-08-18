//  SettingsView.swift
//  CravelyApp
//
//  Created by ayman moh on 23/07/2026.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @State private var showResetConfirmation: Bool = false
    @State private var showSettingsAlert: Bool = false
    @FocusState private var isPriceFieldFocused: Bool

    // MARK: - Dependencies
    @Environment(SettingsViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    
    private var notificationManager = NotificationManager.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerView
                habitView
                notificationsView
                dataView

                Spacer()
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .contentShape(Rectangle())
        .onTapGesture {
            isPriceFieldFocused = false
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isPriceFieldFocused = false
                }
            }
        }
        .alert("Notifications Disabled", isPresented: $showSettingsAlert) {
            Button("Open Settings") {
                notificationManager.openSystemSettings()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please turn on notifications in iOS Settings to enable reminders.")
        }
        .onAppear {
            // Make sure the toggle reflects reality as soon as the view shows up,
            // in case the user changed permissions or the schedule failed while
            // this view wasn't visible.
            notificationManager.checkAuthorizationStatus()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            notificationManager.checkAuthorizationStatus()
        }
    }
}

// MARK: - Header
private extension SettingsView {
    var headerView: some View {
        HStack {
            Text("Cravely")
                .font(.system(size: 28))
                .fontWeight(.heavy)
                .foregroundStyle(.white)

            Text("Settings")
                .font(.system(size: 28))
                .bold()
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
    }
}

// MARK: - Habit Section
private extension SettingsView {

    var habitView: some View {
        VStack(spacing: 15) {
            Text("Habit")
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 15) {
                habitTypeRow
                Divider().background(Color.white.opacity(0.1))
                brandOrProductRow
                Divider().background(Color.white.opacity(0.1))
                priceRow
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                Color(red: 17/255, green: 17/255, blue: 17/255)
                    .cornerRadius(14)
            )
        }
    }

    var habitTypeRow: some View {
        HStack {
            Text("Type")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .foregroundStyle(.white)

            Spacer()

            habitTypeButton(for: .cigarettes)
            habitTypeButton(for: .cannabis)
        }
    }

    var brandOrProductRow: some View {
        HStack {
            Text(viewModel.habitType == .cigarettes ? "Brand" : "Product")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .foregroundStyle(.white)

            Spacer()

            Menu {
                if viewModel.habitType == .cigarettes {
                    ForEach(SettingsViewModel.CigaretteBrand.allCases) { brand in
                        Button {
                            viewModel.selectBrandOrProduct(brand.rawValue)
                        } label: {
                            if brand.rawValue == viewModel.selectedBrand {
                                Label(brand.rawValue, systemImage: "checkmark")
                            } else {
                                Text(brand.rawValue)
                            }
                        }
                    }
                } else {
                    ForEach(SettingsViewModel.CannabisProduct.allCases) { product in
                        Button {
                            viewModel.selectBrandOrProduct(product.rawValue)
                        } label: {
                            if product.rawValue == viewModel.selectedBrand {
                                Label(product.rawValue, systemImage: "checkmark")
                            } else {
                                Text(product.rawValue)
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color(white: 0.5))

                    Text(viewModel.selectedBrand)
                        .font(.system(size: 16))
                        .foregroundStyle(Color(white: 0.6))
                }
            }
            .sensoryFeedback(.impact(weight: .light, intensity: 0.5), trigger: viewModel.selectedBrand)
        }
    }

    var priceRow: some View {
        @Bindable var vm = viewModel
        
        return HStack {
            Text(viewModel.habitType == .cigarettes ? "Price / pack" : "Price / item")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .foregroundStyle(.white)

            Spacer()

            HStack(spacing: 4) {
                Text("$")
                    .foregroundStyle(Color(white: 0.6))

                TextField(
                    "0",
                    value: $vm.packPrice,
                    format: .number.precision(.fractionLength(0...2))
                )
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(Color(white: 0.6))
                .frame(width: 70)
                .focused($isPriceFieldFocused)
            }
            .font(.system(size: 16))
        }
    }

    func habitTypeButton(for type: SettingsViewModel.HabitType) -> some View {
        let isSelected = viewModel.habitType == type

        return Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                viewModel.habitType = type
            }
        } label: {
            HStack(spacing: 6) {
                Text(type.emoji)
                Text(type.rawValue)
                    .fontWeight(.medium)
            }
            .font(.system(size: 14))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .foregroundStyle(isSelected ? .green : Color(white: 0.6))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        isSelected
                            ? Color(red: 0.1098, green: 0.1569, blue: 0.1059)
                            : Color(white: 0.16)
                    )
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(weight: .light, intensity: 0.5), trigger: viewModel.habitType)
    }
}

// MARK: - Notifications Section
private extension SettingsView {
    var notificationsView: some View {
        @Bindable var vm = viewModel

        return VStack(spacing: 15) {
            Text("Notifications")
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 15) {
                // MARK: Daily Reminder Toggle
                HStack {
                    Text("Daily reminders")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    Spacer()

                    Toggle("", isOn: Binding(
                        // Source of truth is the actual system-scheduled notification,
                        // not just the cached preference — so the toggle can never show
                        // "on" when nothing is really scheduled (e.g. permission was
                        // revoked, or scheduling silently failed).
                        get: { notificationManager.isDailyReminderScheduled && notificationManager.isAuthorized },
                        set: { newValue in
                            if newValue {
                                Task { @MainActor in
                                    let granted = await notificationManager.requestAuthorization()
                                    if granted {
                                        vm.dailyReminders = true
                                        await notificationManager.schedule8PMDailyReminder()
                                    } else if notificationManager.isDenied {
                                        vm.dailyReminders = false
                                        showSettingsAlert = true
                                    } else {
                                        vm.dailyReminders = false
                                    }
                                }
                            } else {
                                vm.dailyReminders = false
                                notificationManager.cancelDailyReminder()
                            }
                        }
                    ))
                    .labelsHidden()
                    .tint(.green)
                    .sensoryFeedback(.impact(weight: .light, intensity: 0.5), trigger: notificationManager.isDailyReminderScheduled)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                Color(red: 17/255, green: 17/255, blue: 17/255)
                    .cornerRadius(14)
            )
        }
    }
}

// MARK: - Data Section
private extension SettingsView {

    var dataView: some View {
        VStack(spacing: 15) {
            Text("Data")
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                showResetConfirmation = true
            } label: {
                HStack {
                    Text("Reset all data")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)

                    Spacer()
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(
                    Color(red: 17/255, green: 17/255, blue: 17/255)
                        .cornerRadius(14)
                )
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.impact(weight: .medium, intensity: 0.5), trigger: showResetConfirmation)
            .confirmationDialog(
                "Reset all data?",
                isPresented: $showResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Reset all data", role: .destructive) {
                    resetAllData()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently clear your logged taps and reset preferences.")
            }
        }
    }

    /// Clears SwiftData logs and resets all user preferences to default state
    private func resetAllData() {
        // 1. Delete all logged Taps from SwiftData
        do {
            try modelContext.delete(model: Tap.self)
            try modelContext.save()
        } catch {
            print("Failed to delete Tap records from SwiftData: \(error)")
        }

        // 2. Clear scheduled and pending notifications
        NotificationManager.shared.cancelAllNotifications()

        // 3. Reset ViewModel properties and clear UserDefaults
        viewModel.resetToDefaults()
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
        .environment(SettingsViewModel())
}
