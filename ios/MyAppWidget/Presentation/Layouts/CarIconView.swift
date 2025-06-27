//
//  CarIconView.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 27.06.2025.
//

import SwiftUI

struct CarIconView: View {
    
    var body: some View {
        Image(.licensePlateIcon)
            .renderingMode(.template)
            .foregroundStyle(.appBlue)
    }
}

#Preview {
    CarIconView()
}
