//
//  View+Extension.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 24.06.2025.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func customFont(size: Double, weight: Font.Weight = .regular, color: Color? = .appPrimary) -> some View {
        if let color = color {
            self
                .font(.system(size: size, weight: weight))
                .foregroundColor(color)
        } else {
            self
                .font(.system(size: size, weight: weight))
        }
    }
}
