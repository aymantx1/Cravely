//
//  CravelyWidget.swift
//  CravelyWidget
//

import WidgetKit
import SwiftUI

struct CravelyWidget: Widget {
    let kind: String = "CravelyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CravelyProvider()) { entry in
            CravelyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Cravely")
        .description("See your streak and savings at a glance.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}
