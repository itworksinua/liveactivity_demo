//
//  ParkingCompactTrailingView.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 01.07.2025.
//

import SwiftUI
import WidgetKit

struct ParkingCompactTrailingView: View {
    let context: ActivityViewContext<ParkingLiveActivityAttributes>
    
    var body: some View {
        if context.isStale {
            Text(context.attributes.labels.ended)
                .customFont(size: 12, weight: .bold, color: .appBlue)
        } else {
            CountdownTextView(context: context, fontSize: 12, width: 60)
        }
    }
}
