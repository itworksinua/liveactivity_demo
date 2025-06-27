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
    let foregroundColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            centerSection
            
            bottomSection
        }
    }
    
    private var attributes: ParkingLiveActivityAttributes {
        context.attributes
    }
    
    private var labels: ParkingLiveActivityAttributes.Labels { attributes.labels }
    private var start: Date { attributes.startDate }
    private var end: Date { attributes.endDate }
    private var totalDuration: Duration { .seconds(max(0, end.timeIntervalSince(start))) }
    
    private var centerSection: some View {
        HStack(spacing: 20) {
            dateTimeColumn(for: start)
            
            progressView
            
            dateTimeColumn(for: end)
        }
    }
    
    private var progressView: some View {
        ProgressView(
            timerInterval: start ... end,
            countsDown: true
        )
        .labelsHidden()
        .progressViewStyle(.linear)
        .tint(.appBlue)
        .rotationEffect(.degrees(180))
        .scaleEffect(y: 1.5)
        .clipShape(.capsule(style: .continuous))
    }
    
    private var bottomSection: some View {
        GeometryReader { proxy in
            let columnWidth = proxy.size.width / 3
            
            HStack(spacing: .zero) {
                durationColumn(title: labels.currentDuration, alignment: .leading) {
                    Text(timerInterval: start ... end, countsDown: false)
                        .customFont(size: 16, weight: .bold, color: foregroundColor)
                        .multilineTextAlignment(.leading)
                        .frame(width: columnWidth)
                }
                
                durationColumn(title: labels.remainingTime, alignment: .center) {
                    Text(timerInterval: start ... end, countsDown: true)
                        .customFont(size: 20, weight: .bold, color: .appBlue)
                        .multilineTextAlignment(.center)
                        .frame(width: columnWidth)
                }
                
                durationColumn(title: labels.totalDuration, alignment: .trailing) {
                    Text(totalDuration, format: .time(pattern: .hourMinuteSecond))
                        .customFont(size: 16, weight: .bold, color: foregroundColor)
                        .frame(width: columnWidth, alignment: .trailing)
                }
            }
        }
        .frame(height: 40)
    }
    
    private func dateTimeColumn(for date: Date) -> some View {
        VStack(spacing: 4) {
            Text(date.formatted(as: .dateWithDots))
                .customFont(size: 14, weight: .regular, color: foregroundColor)
            
            Text(date.formatted(as: .time))
                .customFont(size: 16, weight: .bold, color: foregroundColor)
        }
    }
    
    private func durationColumn(
        title: String,
        alignment: HorizontalAlignment,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: alignment, spacing: 4) {
            Text(title)
                .lineLimit(1)
                .customFont(size: 12, weight: .regular, color: foregroundColor.opacity(0.5))
            
            content()
        }
    }
}
