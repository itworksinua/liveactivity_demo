//
//  PriceView.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 27.06.2025.
//

import SwiftUI

struct PriceView: View {
    let price: (amount: Double, currency: String)
    let style: ParkingLiveActivityStyle
    
    var body: some View {
        Text(String(format: "%.2f %@", price.amount, price.currency))
            .customFont(size: 18, weight: .semibold, color: style.foregroundColor)
    }
}
