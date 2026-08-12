//
//  SettingsView.swift
//  CravelyApp
//
//  Created by ayman moh on 23/07/2026.
//

import SwiftUI

struct SettingsView: View {
    //Note needs work
    @State private var showResetConfirmation: Bool = false

 
    // MARK: - Body
    @Environment(AppModel.self) private var appModel

    var body: some View {
        
        VStack(spacing: 20) {
            headerView
            habitView
            notificationsView
            dataView

            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

// MARK: - Header

private extension SettingsView {
    

    var headerView: some View {
        HStack {
            Text("Cravely")
                .font(.system(size: 28))
                .fontWeight(.heavy)

            Text("Settings")
                .font(.system(size: 28))
                .bold()
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
    }
}

// MARK: - Habit section

private extension SettingsView {

    var habitView: some View {
        VStack(spacing: 15) {
            Text("Habit")
                .font(.system(size: 16))
                .opacity(0.5)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 15) {
                habitTypeRow
                Divider()
                brandRow
                Divider()
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

            Spacer()

            habitTypeButton(for: .ciggeretes)
            habitTypeButton(for: .cannabis)
        }
    }
    @ViewBuilder
    var brandRow: some View {
        @Bindable var model = appModel
        HStack {
            Text("Brand")
                .font(.system(size: 16))
                .fontWeight(.semibold)

            Spacer()

            Menu {
                ForEach(AppModel.CigaretteBrand.allCases) { brand in
                    Button {
                        model.selectedBrand = brand
                    } label: {
                        if brand == model.selectedBrand {
                            Label(brand.rawValue, systemImage: "checkmark")
                        } else {
                            Text(brand.rawValue)
                        }
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color(white: 0.5))

                    Text(model.selectedBrand.rawValue)
                        .font(.system(size: 16))
                        .foregroundStyle(Color(white: 0.6))
                }
            }
        }
    }

    var priceRow: some View {
        @Bindable var model = appModel
        return HStack {
            Text("Price / pack")
                .font(.system(size: 16))
                .fontWeight(.semibold)

            Spacer()

            HStack(spacing: 4) {
                Text("$")
                    .foregroundStyle(Color(white: 0.6))

                TextField(
                    "0",
                    value: $model.packPrice,
                    format: .number
                        .precision(.fractionLength(0...2))
                        .locale(Locale(identifier: "en_US"))
                )
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(Color(white: 0.6))
                .frame(width: 60)
            }
            .font(.system(size: 16))
        }
    }
    @ViewBuilder
    func habitTypeButton(for type: AppModel.HabitType) -> some View {
        @Bindable var model = appModel
        let isSelected = model.habitType == type

        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                model.habitType = type
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
    }
}


// MARK: - Notifications section
private extension SettingsView {
    var notificationsView: some View {
        @Bindable var model = appModel
        
        return VStack(spacing: 15) {
            Text("Notifications")
                .font(.system(size: 16))
                .opacity(0.5)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text("Daily reminders")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)

                Spacer()

                Toggle("", isOn: $model.dailyReminders)
                    .labelsHidden()
                    .tint(.green)
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

// MARK: - Data section

private extension SettingsView {

    var dataView: some View {
        VStack(spacing: 15) {
            Text("Data")
                .font(.system(size: 16))
                .opacity(0.5)
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
            .confirmationDialog(
                "Reset all data?",
                isPresented: $showResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Reset all data", role: .destructive) {
                    // TODO: hook up actual reset logic
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This can't be undone.")
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .environment(AppModel())

}
