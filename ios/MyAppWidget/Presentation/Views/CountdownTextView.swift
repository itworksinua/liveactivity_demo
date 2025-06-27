//
//  CountdownTextView.swift
//  Runner
//
//  Created by Dmytro Grytsenko on 27.06.2025.
//

import SwiftUI
import WidgetKit

struct CountdownTextView: View {
    let context: ActivityViewContext<ParkingLiveActivityAttributes>
    var fontSize: CGFloat = 20
    var fontWeight: Font.Weight = .bold
    var color: Color = .appBlue
    let width: CGFloat
    
    var body: some View {
        Text(timerInterval: start ... end, countsDown: true)
            .customFont(size: fontSize, weight: fontWeight, color: color)
            .multilineTextAlignment(.center)
            .frame(width: width)
    }
    
    private var start: Date { context.attributes.startDate }
    private var end: Date { context.attributes.endDate }
}
