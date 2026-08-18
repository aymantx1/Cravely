//  NotificationManager.swift
//  CravelyApp

import Foundation
import UserNotifications
import Observation
import UIKit

@Observable
final class NotificationManager {
    static let shared = NotificationManager()
    
    // MARK: - Observable Properties
    var isAuthorized: Bool = false
    var isDenied: Bool = false
    /// Reflects whether the 8PM daily reminder is *actually* scheduled with the
    /// system (as opposed to a cached preference), so the UI can never drift
    /// out of sync with reality.
    var isDailyReminderScheduled: Bool = false
    
    // MARK: - Private Identifiers
    private let notificationCenter = UNUserNotificationCenter.current()
    private let dailyReminderIdentifier = "com.cravelyapp.dailyReminder"
    
    private init() {
        checkAuthorizationStatus()
    }
    
    // MARK: - Authorization
    
    /// Checks current notification permission status asynchronously
    func checkAuthorizationStatus() {
        notificationCenter.getNotificationSettings { settings in
            Task { @MainActor in
                self.isAuthorized = (settings.authorizationStatus == .authorized)
                self.isDenied = (settings.authorizationStatus == .denied)
                await self.refreshDailyReminderStatus()
            }
        }
    }
    
    /// Requests authorization or updates state if denied
    @discardableResult
    func requestAuthorization() async -> Bool {
        let settings = await notificationCenter.notificationSettings()
        
        if settings.authorizationStatus == .denied {
            await MainActor.run {
                self.isDenied = true
                self.isAuthorized = false
            }
            return false
        }
        
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            await MainActor.run {
                self.isAuthorized = granted
                self.isDenied = !granted
            }
            return granted
        } catch {
            print("Failed to request notification permission: \(error.localizedDescription)")
            await MainActor.run {
                self.isAuthorized = false
            }
            return false
        }
    }
    
    /// Opens the iOS System Settings page for Cravely
    func openSystemSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Scheduled Notifications
    
    /// Schedules a daily notification at 8:00 PM (20:00)
    func schedule8PMDailyReminder() async {
        let granted = await requestAuthorization()
        guard granted else {
            cancelDailyReminder()
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Cravely Check-in 🌿"
        content.body = "Don't forget to log your cravings today! Keep your streak strong."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: dailyReminderIdentifier,
            content: content,
            trigger: trigger
        )
        
        cancelDailyReminder()
        
        do {
            try await notificationCenter.add(request)
            await MainActor.run {
                self.isDailyReminderScheduled = true
            }
            print("Successfully scheduled daily 8:00 PM reminder.")
        } catch {
            print("Error scheduling 8:00 PM notification: \(error.localizedDescription)")
            await MainActor.run {
                self.isDailyReminderScheduled = false
            }
        }
    }
    
    // MARK: - Status Sync
    
    /// Queries the system for pending notification requests and updates
    /// `isDailyReminderScheduled` to match reality. Call this whenever the
    /// UI needs to trust the current state (view appears, app foregrounds,
    /// authorization changes, etc).
    @discardableResult
    func refreshDailyReminderStatus() async -> Bool {
        let pending = await notificationCenter.pendingNotificationRequests()
        let isScheduled = pending.contains { $0.identifier == dailyReminderIdentifier }
        await MainActor.run {
            self.isDailyReminderScheduled = isScheduled
        }
        return isScheduled
    }
    
    // MARK: - Cancellation Helpers
    
    func cancelDailyReminder() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [dailyReminderIdentifier])
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [dailyReminderIdentifier])
        isDailyReminderScheduled = false
        print("Cancelled daily reminders.")
    }
    
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
        isDailyReminderScheduled = false
        print("Cancelled all notifications.")
    }
}
