//
//  CravelySnapshot.swift
//  CravelyApp / CravelyWidget
//
//  Add this file to BOTH the CravelyApp target and the CravelyWidget
//  extension target (check both boxes in the File Inspector's
//  "Target Membership" section).
//
//  This is the one piece of data the widget actually needs. Rather than
//  having the widget open its own SwiftData container and re-run the
//  streak/savings math, the app computes everything once (it already has
//  to, to show HomeView) and drops a small snapshot into an App Group
//  UserDefaults suite. The widget just reads it. Faster widget loads,
//  and zero risk of the widget's math ever drifting from the app's.
//

import Foundation

struct CravelySnapshot: Codable {
    var totalSaved: Double
    var streak: Int
    var todayCount: Int
    var totalCount: Int
    var lastCraveText: String
    var avgDailySave: Double
    var unitPrice: Double
    var habitEmoji: String
    var selectedBrand: String
    var updatedAt: Date

    /// Shown in widget previews/gallery and before the app has ever run.
    static let placeholder = CravelySnapshot(
        totalSaved: 142.50,
        streak: 6,
        todayCount: 3,
        totalCount: 41,
        lastCraveText: "Today",
        avgDailySave: 23.75,
        unitPrice: 0.73,
        habitEmoji: "🚬",
        selectedBrand: "Marlboro",
        updatedAt: Date()
    )
}

enum SharedStore {
    /// Must exactly match the App Group ID you add to BOTH targets under
    /// Signing & Capabilities → App Groups. See SETUP.md.
    static let appGroupID = "group.com.aymancodes.CravelyApp"

    private static let snapshotKey = "cravely.widget.snapshot"

    static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroupID) ?? .standard
    }

    static func save(_ snapshot: CravelySnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaults.set(data, forKey: snapshotKey)
    }

    static func load() -> CravelySnapshot? {
        guard let data = defaults.data(forKey: snapshotKey),
              let snapshot = try? JSONDecoder().decode(CravelySnapshot.self, from: data)
        else { return nil }
        return snapshot
    }
}
