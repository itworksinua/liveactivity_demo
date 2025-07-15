//
//  ParkingCenterBottomSectionView.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 27.06.2025.
//

import SwiftUI
import WidgetKit

struct ParkingCenterBottomSectionView: View {
    let context: ActivityViewContext<ParkingLiveActivityAttributes>
    let style: ParkingLiveActivityStyle
    
    var body: some View {
        VStack(spacing: 5) {
            topSection
            
            progressView
        }
    }
    
    private var attributes: ParkingLiveActivityAttributes {
        context.attributes
    }
    
    private var foregroundColor: Color { style.foregroundColor }
    private var labels: ParkingLiveActivityAttributes.Labels { attributes.labels }
    private var start: Date { attributes.startDate }
    private var end: Date? { attributes.endDate }
    
    
    private var topSection: some View {
        HStack(alignment: .bottom) {
            timerView
            
            endTimeView
        }
    }
    
    private var timerView: some View {
        Group {
            if let end {
                Text(timerInterval: start ... end, countsDown: true)
            } else {
                Text(start, style: .timer)
            }
        }
        .customFont(size: 52, weight: .bold, color: foregroundColor)
        .multilineTextAlignment(.leading)
    }
    
    @ViewBuilder
    private var endTimeView: some View {
        if let end {
            HStack(alignment: .bottom, spacing: 4) {
                Text(labels.ends)
                    .lineLimit(1)
                    .customFont(size: 13, weight: .bold, color: foregroundColor)
                
                Text(end.formatted(date: .omitted, time: .shortened))
                    .customFont(size: 16, weight: .bold, color: .appBlue)
            }
        }
    }
    
    @ViewBuilder
    private var progressView: some View {
        if let end {
            ProgressView(timerInterval: start ... end, countsDown: true)
                .labelsHidden()
                .progressViewStyle(.linear)
                .tint(.appBlue)
                .scaleEffect(y: 1.3)
                .clipShape(.capsule(style: .continuous))
                .padding(.leading, 5)
        }
    }
}
