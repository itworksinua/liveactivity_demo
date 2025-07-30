//
//  TimerView.swift
//  Runner
//
//  Created by Dmytro Grytsenko on 27.06.2025.
//

import SwiftUI
import WidgetKit

struct TimerView: View {
    let context: ActivityViewContext<ParkingLiveActivityAttributes>
    var fontSize: CGFloat = 52
    var fontWeight: Font.Weight = .bold
    var color: Color = .appBlack
    var width: CGFloat = .infinity
    
    var body: some View {
        Group {
            if let end {
                Text(timerInterval: start ... end, countsDown: true)
            } else {
                Text(start, style: .timer)
            }
        }
        .customFont(size: fontSize, weight: fontWeight, color: color)
        .multilineTextAlignment(.leading)
        .frame(width: width)
    }
    
    private var start: Date { context.state.start }
    private var end: Date? { context.state.end }
}
