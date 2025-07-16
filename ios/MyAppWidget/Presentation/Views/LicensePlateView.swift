//
//  LicensePlateView.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 27.06.2025.
//

import SwiftUI

struct LicensePlateView: View {
    let licensePlate: String
    let style: ParkingLiveActivityStyle
    
    var body: some View {
        IconLabelView(image: .licensePlateIcon, text: licensePlate, style: style)
    }
}
