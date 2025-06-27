//
//  ParkingLiveActivityView.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 24.06.2025.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct ParkingLiveActivityView: View {
    let context: ActivityViewContext<ParkingLiveActivityAttributes>
    
    var body: some View {
        VStack(spacing: 14) {
            topSection
            
            VStack(spacing: 8) {
                centerSection
                
                bottomSection
            }
            .padding(.horizontal, 4)
        }
        .padding(.init(top: 18, leading: 18, bottom: 12, trailing: 18))
        .activityBackgroundTint(.appBackground)
        .activitySystemActionForegroundColor(.appBackground)
        .overlay(content: stroke)     ///Don't use this
    }
    
    private var attributes: ParkingLiveActivityAttributes {
        context.attributes
    }
    
    private var labels: ParkingLiveActivityAttributes.Labels { attributes.labels }
    private var start: Date { attributes.startDate }
    private var end: Date { attributes.endDate }
    private var totalDuration: Duration { .seconds(max(0, end.timeIntervalSince(start))) }
    
    private var topSection: some View {
        ZStack {
            HStack {
                IconLabelView(
                    image: Image(.zoneIdIcon),
                    text: attributes.zoneId
                )
                
                Spacer()
                
                Text(String(format: "%.2f €", context.attributes.price))
                    .customFont(size: 18, weight: .semibold)
            }
            
            IconLabelView(
                image: Image(.licensePlateIcon),
                text: attributes.licensePlate
            )
        }
    }
    
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
    
    @ViewBuilder
    private var bottomSection: some View {
        HStack {
            durationColumn(title: labels.currentDuration, alignment: .leading) {
                Text(start, style: .relative)
                    .customFont(size: 14, weight: .bold)
            }
            
            durationColumn(title: labels.remainingTime, alignment: .leading) {
                Text(end, style: .relative)
                    .customFont(size: 16, weight: .bold, color: .appBlue)
            }
            
            durationColumn(title: labels.totalDuration, alignment: .trailing) {
                Text(totalDuration, format: .units())
                    .customFont(size: 14, weight: .bold)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func dateTimeColumn(for date: Date) -> some View {
        VStack(spacing: 4) {
            Text(date.formatted(as: .dateWithDots))
                .customFont(size: 14, weight: .regular)
            
            Text(date.formatted(as: .time))
                .customFont(size: 16, weight: .bold)
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
                .customFont(size: 12, weight: .regular, color: .appSecondary)
            
            content()
        }
    }
    
    ///Don't use this
    private func stroke() -> some View {
        RoundedRectangle(cornerRadius: 24)
            .inset(by: 1)
            .stroke(.appBlue, lineWidth: 2)
    }
}
