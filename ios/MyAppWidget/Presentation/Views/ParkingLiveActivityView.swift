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
        VStack(spacing: hasEndDate ? 5 : 18) {
            topSection
            
            bottomSection
        }
        .padding(EdgeInsets(top: 14, leading: 20, bottom: hasEndDate ? 16 : 12, trailing: 32))
        .activityBackgroundTint(.appBackground)
        .activitySystemActionForegroundColor(.appBackground)
    }
    
    private var attributes: ParkingLiveActivityAttributes { context.attributes }
    private var hasEndDate: Bool { attributes.endDate != nil }
    
    private var topSection: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(.logo)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 5)
            
            VStack(alignment: .trailing, spacing: 4) {
                LicensePlateView(licensePlate: attributes.licensePlate, style: style)
                
                ZoneIdView(zoneId: attributes.zoneId, style: style)
            }
        }
    }
    
    private var bottomSection: some View {
        ParkingBottomSectionView(context: context, style: style)
    }
}
