//
//  NYCASPStatusWidget.swift
//  NYCASPStatusWidget
//
//  Created by Jia Sheng Ma on 8/15/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), aspStatus: ASPStatus(aspStatus: "N/A", aspStatusDescription: "N/A"))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            let aspStatus = await getASPStatus()
            let entry = SimpleEntry(date: Date(), aspStatus: aspStatus)
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        Task {
            
            let aspStatus = await getASPStatus()
            
            var entries: [SimpleEntry] = []
            let currentDate = Date()
            let nextUpdateDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            let entry = SimpleEntry(date: currentDate, aspStatus: aspStatus)
            entries.append(entry)
            
            let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let aspStatus: ASPStatus
}

struct NYCASPStatusWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("\(entry.aspStatus.date): \(entry.aspStatus.aspStatus)")
    }
}

@main
struct NYCASPStatusWidget: Widget {
    let kind: String = "NYCASPStatusWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NYCASPStatusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct NYCASPStatusWidget_Previews: PreviewProvider {
    static var previews: some View {
        NYCASPStatusWidgetEntryView(entry: SimpleEntry(date: Date(), aspStatus: ASPStatus(aspStatus: "N/A", aspStatusDescription: "N/A")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
