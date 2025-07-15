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
    var fontSize: Double = 17
    var fontWeight: Font.Weight = .bold
    var foregroundColor: Color = .appPrimary
    var spacing: CGFloat = 7
    
    var body: some View {
        HStack(spacing: spacing) {
            Image(image)
            
            Text(text)
                .lineLimit(1)
                .customFont(size: fontSize, weight: fontWeight, color: foregroundColor)
        }
    }
}
