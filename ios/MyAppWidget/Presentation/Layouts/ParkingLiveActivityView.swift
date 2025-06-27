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
            
            ParkingCenterBottomSectionView(
                context: context,
                foregroundColor: .appPrimary
            )
        }
        .padding(.init(top: 18, leading: 18, bottom: 12, trailing: 18))
        .activityBackgroundTint(.appBackground)
        .activitySystemActionForegroundColor(.appBackground)
        .overlay(content: stroke)     ///Don't use this
    }
    
    private var attributes: ParkingLiveActivityAttributes {
        context.attributes
    }
    
    private var topSection: some View {
        ZStack {
            HStack {
                IconLabelView(
                    image: .zoneIdIcon,
                    text: attributes.zoneId
                )
                
                Spacer()
                
                Text(String(format: "%.2f €", context.attributes.price))
                    .customFont(size: 18, weight: .semibold)
            }
            
            IconLabelView(
                image: .licensePlateIcon,
                text: attributes.licensePlate
            )
        }
    }
    
    ///Don't use this
    private func stroke() -> some View {
        RoundedRectangle(cornerRadius: 24)
            .inset(by: 1)
            .stroke(.appBlue, lineWidth: 2)
    }
}
