//
//  ZoneIdView.swift
//  Runner
//
//  Created by Dmytro Grytsenko on 27.06.2025.
//

import SwiftUI

struct ZoneIdView: View {
    let zoneId: String
    let style: ParkingLiveActivityStyle
    
    var body: some View {
        IconLabelView(image: .zoneIdIcon, text: zoneId, style: style)
    }
}
