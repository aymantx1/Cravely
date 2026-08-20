//
//  CravelyWidgetEntryView.swift
//  CravelyWidget
//
//  Mirrors the dark, minimal look of HomeView. One view, switching on
//  widgetFamily, keeps small/medium/lock-screen variants in sync.
//

import SwiftUI
import WidgetKit

struct CravelyWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    var entry: CravelyProvider.Entry

    private var snapshot: CravelySnapshot { entry.snapshot }

    var body: some View {
        switch family {
        case .systemSmall:
            smallView
        case .systemMedium:
            mediumView
        case .accessoryCircular:
            circularView
        case .accessoryRectangular:
            rectangularView
        case .accessoryInline:
            inlineView
        default:
            smallView
        }
    }

    // MARK: - Home Screen: Small

    private var smallView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(snapshot.habitEmoji)
                    .font(.system(size: 18))
                Spacer()
                Text("🔥 \(snapshot.streak)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
            }
            Spacer()
            Text("Total Saved")
                .font(.system(size: 11))
                .foregroundStyle(.white.opacity(0.5))
            Text("$\(snapshot.totalSaved, specifier: "%.2f")")
                .font(.system(size: 26, weight: .heavy))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(Color.black, for: .widget)
    }

    // MARK: - Home Screen: Medium

    private var mediumView: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Total Saved")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.5))
                Text("$\(snapshot.totalSaved, specifier: "%.2f")")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Text("\(snapshot.selectedBrand) • $\(snapshot.unitPrice, specifier: "%.2f")/use")
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.5))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Rectangle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 1)
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 10) {
                statRow(emoji: "🔥", value: "\(snapshot.streak)", label: "streak")
                statRow(emoji: "✅", value: "\(snapshot.totalCount)", label: "resisted")
                statRow(emoji: "🕓", value: snapshot.lastCraveText, label: "last crave")
            }
            .frame(width: 110, alignment: .leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(Color.black, for: .widget)
    }

    private func statRow(emoji: String, value: String, label: String) -> some View {
        HStack(spacing: 6) {
            Text(emoji).font(.system(size: 12))
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text(label)
                    .font(.system(size: 10))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }

    // MARK: - Lock Screen

    // Accessory-family widgets are rendered by the system in its own
    // monochrome tint (varies with wallpaper/Focus), so we deliberately
    // don't hardcode foreground colors here — just structure and content.

    private var circularView: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 1) {
                Text("🔥")
                    .font(.system(size: 14))
                Text("\(snapshot.streak)")
                    .font(.system(size: 15, weight: .bold))
            }
        }
        .containerBackground(.clear, for: .widget)
    }

    private var rectangularView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("$\(snapshot.totalSaved, specifier: "%.2f") saved")
                .font(.system(size: 14, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text("🔥 \(snapshot.streak) day streak")
                .font(.system(size: 12))
                .opacity(0.7)
        }
        .containerBackground(.clear, for: .widget)
    }

    private var inlineView: some View {
        Text("🔥 \(snapshot.streak) streak · $\(snapshot.totalSaved, specifier: "%.2f") saved")
            .containerBackground(.clear, for: .widget)
    }
}

// MARK: - Previews

#Preview(as: .systemSmall) {
    CravelyWidget()
} timeline: {
    CravelyEntry(date: .now, snapshot: .placeholder)
}

#Preview(as: .systemMedium) {
    CravelyWidget()
} timeline: {
    CravelyEntry(date: .now, snapshot: .placeholder)
}
