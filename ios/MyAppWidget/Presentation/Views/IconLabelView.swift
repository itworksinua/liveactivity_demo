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
    let fontSize: Double
    let fontWeight: Font.Weight
    let spacing: CGFloat
    
    init(
        image: ImageResource,
        text: String,
        fontSize: Double = 18,
        fontWeight: Font.Weight = .semibold,
        spacing: CGFloat = 4
    ) {
        self.image = image
        self.text = text
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.spacing = spacing
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            Image(image)
            
            Text(text)
                .lineLimit(1)
                .customFont(size: fontSize, weight: fontWeight)
        }
    }
}
