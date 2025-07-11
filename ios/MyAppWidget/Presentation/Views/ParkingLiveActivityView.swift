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
    
    private let style: ParkingLiveActivityStyle = .light
    
    var body: some View {
        VStack(spacing: 14) {
            topSection
            
            ParkingCenterBottomSectionView(context: context, style: style)
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
                ZoneIdView(zoneId: attributes.zoneId, style: style)
                
                Spacer()
                
                PriceView(price: attributes.price, style: style)
            }
            
            LicensePlateView(licensePlate: attributes.licensePlate, style: style)
        }
    }
    
    private func stroke() -> some View {
        RoundedRectangle(cornerRadius: 24)
            .inset(by: 1)
            .stroke(.appBlue, lineWidth: 2)
    }
}
