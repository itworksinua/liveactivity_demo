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
                Logo()
                    .padding(.horizontal, horizontalPadding)
            } compactTrailing: {
                ParkingCompactTrailingView(context: context)
            } minimal: {
                Logo()
            }
            .keylineTint(Color.red)
        }
    }
    
    @DynamicIslandExpandedContentBuilder
    private func expandedContent(context: ActivityViewContext<ParkingLiveActivityAttributes>) -> DynamicIslandExpandedContent<some View> {
        let attributes = context.attributes
        let style: ParkingLiveActivityStyle = .dark
        
        DynamicIslandExpandedRegion(.leading) {
            Logo(size: .init(width: 40, height: 40))
                .padding(.horizontal, horizontalPadding)
        }
        
        DynamicIslandExpandedRegion(.trailing) {
            ParkingHeaderInfoView(
                licensePlate: attributes.licensePlate,
                zoneId: attributes.zoneId,
                style: style
            )
            .padding(.horizontal, horizontalPadding)
        }
        
        DynamicIslandExpandedRegion(.bottom) {
            ParkingBottomSectionView(context: context, style: style)
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
            labels: .init()
        )
    }
    
    static var previewContentState: ContentState {
        .active(
            start: .now,
            end: .now.addingTimeInterval(80) // 80 sec
        )
    }
}

extension ParkingLiveActivityAttributes.ContentState {
    static var active: ParkingLiveActivityAttributes.ContentState {
        ParkingLiveActivityAttributes.previewContentState
    }
}

#Preview("Lock Screen", as: .content, using: ParkingLiveActivityAttributes.preview) {
    MyAppWidgetLiveActivity()
} contentStates: {
    .active
}
