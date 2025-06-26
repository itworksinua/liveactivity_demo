//
//  MyAppWidgetLiveActivity.swift
//  MyAppWidget
//
//  Created by Dmytro Grytsenko on 24.06.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MyAppWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            ParkingLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                expandedContent(context: context)
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("M")
            }
            .keylineTint(Color.red)
        }
    }
    
    @DynamicIslandExpandedContentBuilder
    private func expandedContent(
        context: ActivityViewContext<LiveActivitiesAppAttributes>
    ) -> DynamicIslandExpandedContent<some View> {
        DynamicIslandExpandedRegion(.leading) {
            Text("Leading")
        }
        DynamicIslandExpandedRegion(.trailing) {
            Text("Trailing")
        }
        DynamicIslandExpandedRegion(.bottom) {
            Text("Bottom")
        }
    }
}

extension LiveActivitiesAppAttributes {
    static var preview: LiveActivitiesAppAttributes {
        LiveActivitiesAppAttributes(
            zoneId: "2.371",
            licensePlate: "AA627KT",
            price: 1.5,
            startDate: .now,
//            endDate: .now.addingTimeInterval(5220) // 1h 27m
            endDate: .now.addingTimeInterval(80) // 80 sec
        )
    }
}

extension LiveActivitiesAppAttributes.ContentState {
    static var empty: LiveActivitiesAppAttributes.ContentState {
        LiveActivitiesAppAttributes.ContentState()
    }
}

#Preview("Lock Screen", as: .content, using: LiveActivitiesAppAttributes.preview) {
    MyAppWidgetLiveActivity()
} contentStates: {
    LiveActivitiesAppAttributes.ContentState.empty
}
