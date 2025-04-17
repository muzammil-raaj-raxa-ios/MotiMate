//
//  QuotesWidget.swift
//  QuotesWidget
//
//  Created by MacBook Pro on 16/04/2025.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), quote: "Loading...", author: "", imageData: Data())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(getEntry())
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = getEntry()
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 60)))
        completion(timeline)
    }
    
    private func getEntry() -> SimpleEntry {
        guard let defaults = UserDefaults(suiteName: "group.quotationAppp") else {
            print("Failed to initialize UserDefaults with suiteName: group.quotationApp")
            return SimpleEntry(date: Date(), quote: "Stay hungry, stay foolish", author: "Steve Jobs", imageData: Data())
        }
        
        let quote = defaults.string(forKey: "quote") ?? "Stay hungry, stay foolish"
        let author = defaults.string(forKey: "author") ?? "Steve Jobs"
        let imageData = defaults.data(forKey: "imageName") ?? Data()
        
        return SimpleEntry(date: Date(), quote: quote, author: author, imageData: imageData)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: String
    let author: String
    let imageData: Data?
}

struct QuotesWidgetEntryView : View {
    var entry: SimpleEntry
    @Environment (\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            if family != .accessoryRectangular {
                if let data = entry.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.black // fallback
                }
            }
            
            VStack(spacing: 5) {
                Text(entry.quote)
                    .foregroundColor(.white)
                    .font(.system(size: family == .accessoryRectangular ? 14 : 16, weight: family == .accessoryRectangular ? .regular : .medium))
                    .padding(.horizontal)
                
                if family != .accessoryRectangular {
                    Text("- \(entry.author)")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .light))
                        .italic()
                }
            }
        }
    }
}

struct QuotesWidget: Widget {
    let kind: String = "QuotesWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            QuotesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quote Widget")
        .description("Daily Motivational Quotes.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryRectangular])
    }
}


struct QuotesWidget_Previews: PreviewProvider {
    static var previews: some View {
        QuotesWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            quote: "Stay hungry, stay foolish",
            author: "Steve Jobs",
            imageData: Data()
        ))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

