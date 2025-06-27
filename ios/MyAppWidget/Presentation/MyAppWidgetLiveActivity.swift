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
    private let horizontalPadding: CGFloat = 4
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ParkingLiveActivityAttributes.self) { context in
            ParkingLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                expandedContent(context: context)
            } compactLeading: {
                CarIconView()
                    .padding(.horizontal, horizontalPadding)
            } compactTrailing: {
                CountdownTextView(context: context, fontSize: 12, width: 60)
            } minimal: {
                CarIconView()
            }
            .keylineTint(Color.red)
        }
    }
    
    @DynamicIslandExpandedContentBuilder
    private func expandedContent(context: ActivityViewContext<ParkingLiveActivityAttributes>) -> DynamicIslandExpandedContent<some View> {
        let style: ParkingLiveActivityStyle = .dark
        
        DynamicIslandExpandedRegion(.leading) {
            ZoneIdView(zoneId: context.attributes.zoneId, style: style)
                .padding(.horizontal, horizontalPadding)
        }
        
        DynamicIslandExpandedRegion(.trailing) {
            PriceView(price: context.attributes.price, style: style)
                .padding(.horizontal, horizontalPadding)
        }
        
        DynamicIslandExpandedRegion(.bottom) {
            ParkingCenterBottomSectionView(context: context, style: style)
                .padding(.horizontal, horizontalPadding)
        }
    }
}

// MARK: - Preview

extension ParkingLiveActivityAttributes {
    static var preview: ParkingLiveActivityAttributes {
        ParkingLiveActivityAttributes(
            zoneId: "2.371",
            licensePlate: "AA627KT",
            price: .init(amount: 1.5, currencySymbol: "€"),
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
