//
//  CravelyProvider.swift
//  CravelyWidget
//

import WidgetKit

struct CravelyEntry: TimelineEntry {
    let date: Date
    let snapshot: CravelySnapshot
}

struct CravelyProvider: TimelineProvider {

    func placeholder(in context: Context) -> CravelyEntry {
        CravelyEntry(date: Date(), snapshot: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (CravelyEntry) -> Void) {
        let snapshot = SharedStore.load() ?? .placeholder
        completion(CravelyEntry(date: Date(), snapshot: snapshot))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CravelyEntry>) -> Void) {
        let snapshot = SharedStore.load() ?? .placeholder
        let entry = CravelyEntry(date: Date(), snapshot: snapshot)

        // The app calls WidgetCenter.shared.reloadAllTimelines() the moment a
        // craving is resisted, so the widget updates immediately in normal use.
        // This hourly fallback just keeps "Last crave" (e.g. "Today" -> "1d ago")
        // and streak state honest if the app hasn't been opened in a while.
        let nextRefresh = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
            ?? Date().addingTimeInterval(3600)
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }
}
