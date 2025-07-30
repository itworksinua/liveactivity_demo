//
//  ParkingBottomSectionView.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 27.06.2025.
//

import SwiftUI
import WidgetKit

struct ParkingBottomSectionView: View {
    @State private var leadingWidth: CGFloat = .zero
    
    let context: ActivityViewContext<ParkingLiveActivityAttributes>
    let style: ParkingLiveActivityStyle
    
    
    var body: some View {
        VStack(spacing: isReservationLightStyle ?  15 : 5) {
            topSection
            
            progressView
        }
        .measureSize { size in
            leadingWidth = size.width * 0.6
        }
    }
    
    private var attributes: ParkingLiveActivityAttributes { context.attributes }
    private var foregroundColor: Color { style.foregroundColor }
    private var state: ParkingLiveActivityAttributes.State { context.state }
    private var labels: ParkingLiveActivityAttributes.Labels { attributes.labels }
    private var start: Date { state.start }
    private var end: Date? { context.state.end }
    private var isActiveState: Bool { state.isActive }
    private var isReservationLightStyle: Bool { !isActiveState && style == .light }
    
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
                
                DateView(context: context, color: foregroundColor)
                    .applyIf(style.isDark) {
                        $0.frame(height: 33)
                    }
            }
            .frame(width: leadingWidth, alignment: .leading)
            .layoutPriority(1)
            
            VStack(alignment: .trailing, spacing: .zero) {
                timeLabel(title: labels.start, time: start)
                
                timeLabel(title: labels.ends, time: end)
                    .padding(.bottom, isReservationLightStyle ?  4 : .zero)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    private var topActiveSection: some View {
        HStack(alignment: .bottom) {
            TimerView(context: context, color: foregroundColor)
            
            timeLabel(title: labels.ends, time: end)
                .padding(.bottom, 9)
        }
        .applyIf(style.isDark) {
            $0.frame(height: 45)
        }
    }
    
    @ViewBuilder
    private func timeLabel(title: String, time: Date?) -> some View {
        if let time {
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
    }
    
    @ViewBuilder
    private var progressView: some View {
        if isActiveState, let end {
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
