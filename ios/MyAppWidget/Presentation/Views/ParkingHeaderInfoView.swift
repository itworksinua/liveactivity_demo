//
//  ParkingHeaderInfoView.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 16.07.2025.
//

import SwiftUI

struct ParkingHeaderInfoView: View {
    let licensePlate: String
    let zoneId: String
    let style: ParkingLiveActivityStyle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            LicensePlateView(licensePlate: licensePlate, style: style)
            
            ZoneIdView(zoneId: zoneId, style: style)
        }
    }
}

#Preview {
    ParkingHeaderInfoView(licensePlate: "AA627KT", zoneId: "2.371", style: .light)
}
