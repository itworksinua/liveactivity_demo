//
//  DateView.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 30.07.2025.
//

import SwiftUI
import WidgetKit

struct DateView: View {
    let context: ActivityViewContext<ParkingLiveActivityAttributes>
    var fontSize: CGFloat = 38
    var fontWeight: Font.Weight = .bold
    var color: Color
    var dateFormat: Date.DateFormat = .dateWithDots
    
    var body: some View {
        Text(start.formatted(as: dateFormat))
            .minimumScaleFactor(0.75)
            .customFont(size: fontSize, weight: fontWeight, color: color)
    }
    
    private var start: Date { context.state.start }
}
