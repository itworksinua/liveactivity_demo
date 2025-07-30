//
//  ParkingBottomSectionView.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 27.06.2025.
//

import SwiftUI
import WidgetKit

struct ParkingBottomSectionView: View {
    let context: ActivityViewContext<ParkingLiveActivityAttributes>
    let style: ParkingLiveActivityStyle
    
    var body: some View {
        VStack(spacing: 5) {
            topSection
            
            progressView
        }
    }
    
    private var attributes: ParkingLiveActivityAttributes { context.attributes }
    private var foregroundColor: Color { style.foregroundColor }
    private var state: ParkingLiveActivityAttributes.State { context.state }
    private var labels: ParkingLiveActivityAttributes.Labels { attributes.labels }
    private var start: Date { state.start }
    private var end: Date? { context.state.end }
    
    @ViewBuilder
    private var topSection: some View {
        switch state {
        case .reservation: topReservationSection
        case .active: topActiveSection
        }
    }
    
    private var topReservationSection: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                IconLabelView(image: .calendarClockIcon, text: labels.parkingStarts, fontSize: 13, style: style)
                
                Text(start.formatted(as: .dateWithDots))
                    .customFont(size: 38, weight: .bold, color: foregroundColor)
                    .applyIf(style.isDark) {
                        $0.frame(height: 33)
                    }
            }
            .layoutPriority(1)
            
            VStack(spacing: .zero) {
                startTimeView
                
                endTimeView
                    .padding(.bottom, 4)
            }
        }
    }
    
    private var topActiveSection: some View {
        HStack(alignment: .bottom) {
            TimerView(context: context, color: foregroundColor)
            
            endTimeView
                .padding(.bottom, 9)
        }
        .applyIf(style.isDark) {
            $0.frame(height: 45)
        }
    }
    
    private var startTimeView: some View {
        timeLabelView(title: labels.ends, time: start)
    }
    
    @ViewBuilder
    private var endTimeView: some View {
        if let end {
            timeLabelView(title: labels.ends, time: end)
        }
    }
    
    private func timeLabelView(title: String, time: Date) -> some View {
        HStack(alignment: .bottom, spacing: 4) {
            Text(title)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .customFont(size: 13, weight: .bold, color: foregroundColor)
                .padding(.bottom, 2)
            
            Text(time.formatted(date: .omitted, time: .shortened))
                .customFont(size: 20, weight: .bold, color: style.accentColor)
                .layoutPriority(1)
        }
    }
    
    @ViewBuilder
    private var progressView: some View {
        if state.isActive, let end {
            ZStack {
                Capsule()
                    .fill(.appPurpleLight)
                    .frame(height: 5)
                
                ProgressView(timerInterval: start ... end, countsDown: true)
                    .labelsHidden()
                    .progressViewStyle(.linear)
                    .tint(.appBlue)
                    .scaleEffect(y: 1.3)
                    .clipShape(.capsule(style: .continuous))
            }
            .padding(.leading, 5)
        }
    }
}
