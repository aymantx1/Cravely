//
//  HomeViewModel.swift
//  CravelyApp
//
//  Created by ayman moh on 11/08/2026.
//

import SwiftUI
import SwiftData
import Foundation
import Observation

@Observable
class HomeViewModel {
    
    // MARK: - Actions
    
    /// Creates and persists a new craving/consumption log (`Tap`) using active settings.
    func recordTap(context: ModelContext, settings: SettingsViewModel) {
        let newTap = Tap(
            brand: settings.selectedBrand,
            price: settings.unitPrice
        )
        
        context.insert(newTap)
        
        do {
            try context.save()
            settings.totalResisted += 1
        } catch {
            print("Failed to save tap: \(error)")
        }
    }
    
    // MARK: - Stats Calculations
    
    /// Returns taps logged during the current calendar day.
    func todayTaps(from taps: [Tap]) -> [Tap] {
        let calendar = Calendar.current
        return taps.filter { calendar.isDateInToday($0.time) }
    }
    
    /// Count of taps logged today.
    func todayTapsCount(from taps: [Tap]) -> Int {
        todayTaps(from: taps).count
    }
    
    /// Calculates money saved today based on logged taps.
    func todayTotalCost(from taps: [Tap]) -> Double {
        todayTaps(from: taps).reduce(0.0) { $0 + $1.price }
    }
    
    /// Calculates total money saved across all time.
    func allTimeTotalCost(from taps: [Tap]) -> Double {
        taps.reduce(0.0) { $0 + $1.price }
    }

    /// Calculates readable relative string for the last craving recorded.
    func lastCraveText(from taps: [Tap]) -> String {
        guard let latestTap = taps.first else { return "None yet" }
        let calendar = Calendar.current
        
        if calendar.isDateInToday(latestTap.time) {
            return "Today"
        } else if calendar.isDateInYesterday(latestTap.time) {
            return "Yesterday"
        } else {
            let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: latestTap.time), to: calendar.startOfDay(for: Date())).day ?? 0
            return "\(days)d ago"
        }
    }

    /// Calculates the average money saved per active day.
    func averageDailySave(from taps: [Tap]) -> Double {
        guard let oldestTap = taps.last else { return 0.0 }
        let calendar = Calendar.current
        let startOfOldest = calendar.startOfDay(for: oldestTap.time)
        let startOfToday = calendar.startOfDay(for: Date())
        let daysCount = max(1, (calendar.dateComponents([.day], from: startOfOldest, to: startOfToday).day ?? 0) + 1)
        
        return allTimeTotalCost(from: taps) / Double(daysCount)
    }

    /// Calculates consecutive active days logged. Resets if a day was missed.
    func currentStreak(from taps: [Tap]) -> Int {
        guard !taps.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let activeDates = Set(taps.map { calendar.startOfDay(for: $0.time) })
        let today = calendar.startOfDay(for: Date())
        
        var checkDate = today
        // If no taps recorded today yet, check starting from yesterday to keep active streak intact
        if !activeDates.contains(today) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: today) else { return 0 }
            checkDate = yesterday
        }
        
        var streak = 0
        while activeDates.contains(checkDate) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = previousDay
        }
        
        return streak
    }
}
