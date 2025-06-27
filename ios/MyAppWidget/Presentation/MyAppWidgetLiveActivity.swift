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
        ActivityConfiguration(for: ParkingLiveActivityAttributes.self) { context in
            ParkingLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                expandedContent(context: context)
            } compactLeading: {
                CarIconView()
                    .padding(.horizontal, 4)
            } compactTrailing: {
                CountdownTextView(context: context, fontSize: 12, width: 60)
            } minimal: {
                CarIconView()
            }
            .keylineTint(Color.red)
        }
    }
    
    @DynamicIslandExpandedContentBuilder
    private func expandedContent(
        context: ActivityViewContext<ParkingLiveActivityAttributes>
    ) -> DynamicIslandExpandedContent<some View> {
        DynamicIslandExpandedRegion(.leading) {
            ZoneIdView(zoneId: context.attributes.zoneId, style: .dark)
        }
        DynamicIslandExpandedRegion(.trailing) {

        }
        
        DynamicIslandExpandedRegion(.center) {
            
                
        }
        
        DynamicIslandExpandedRegion(.bottom) {
            ParkingCenterBottomSectionView(context: context, style: .dark)
        }
    }
}

extension ParkingLiveActivityAttributes {
    static var preview: ParkingLiveActivityAttributes {
        ParkingLiveActivityAttributes(
            zoneId: "2.371",
            licensePlate: "AA627KT",
            price: 1.5,
            startDate: .now,
//            endDate: .now.addingTimeInterval(5220), // 1h 27m
            endDate: .now.addingTimeInterval(80), // 80 sec
            labels: .init()
        )
    }
}

extension ParkingLiveActivityAttributes.ContentState {
    static var empty: ParkingLiveActivityAttributes.ContentState {
        ParkingLiveActivityAttributes.ContentState()
    }
}

#Preview("Lock Screen", as: .content, using: ParkingLiveActivityAttributes.preview) {
    MyAppWidgetLiveActivity()
} contentStates: {
    ParkingLiveActivityAttributes.ContentState.empty
}
