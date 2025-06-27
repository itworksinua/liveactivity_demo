//
//  MinimalView.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 27.06.2025.
//

import SwiftUI

struct MinimalView: View {
    var body: some View {
        Image(.licensePlateIcon)
            .renderingMode(.template)
            .foregroundStyle(.appBackground)
    }
}

#Preview {
    MinimalView()
}
