//
//  ParkingCompactTrailingView.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 01.07.2025.
//

import SwiftUI
import WidgetKit

struct ParkingCompactTrailingView: View {
    let context: ActivityViewContext<ParkingLiveActivityAttributes>
    
    var body: some View {
        switch context.state {
        case .reservation: reservationView
        case .active: activeView
        }
    }
    
    private var reservationView: some View {
        let start = context.state.start
        let isToday = Calendar.current.isDateInToday(start)
        
        return DateView(
            context: context,
            fontSize: 12,
            fontWeight: .bold,
            color: .appPurpleLight,
            dateFormat: isToday ? .time : .dateWithDots
        )
    }
    
    @ViewBuilder
    private var activeView: some View {
        if context.isStale {
            Text(context.attributes.labels.ended)
                .customFont(size: 12, weight: .bold, color: .appPurpleLight)
        } else {
            TimerView(
                context: context,
                fontSize: 12,
                color: .appPurpleLight,
                width: 60
            )
        }
    }
}
