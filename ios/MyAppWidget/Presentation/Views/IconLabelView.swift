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
    var fontSize: Double = 16
    var fontWeight: Font.Weight = .bold
    var foregroundColor: Color = .appPrimary
    var spacing: CGFloat = 5
    
    var body: some View {
        HStack(spacing: spacing) {
            Image(image)
                .frame(width: 22, height: 22)
            
            Text(text)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .customFont(size: fontSize, weight: fontWeight, color: foregroundColor)
        }
    }
}
