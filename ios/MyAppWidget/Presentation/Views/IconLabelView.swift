//
//  IconLabelView.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 24.06.2025.
//

import SwiftUI

struct IconLabelView: View {
    let image: ImageResource
    let text: String
    var fontSize: Double = 18
    var fontWeight: Font.Weight = .semibold
    var foregroundColor: Color = .appPrimary
    var spacing: CGFloat = 4
    
    var body: some View {
        HStack(spacing: spacing) {
            Image(image)
            
            Text(text)
                .lineLimit(1)
                .customFont(size: fontSize, weight: fontWeight, color: foregroundColor)
        }
    }
}
