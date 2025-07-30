//
//  View+Extension.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 24.06.2025.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func customFont(size: Double, weight: Font.Weight = .regular, color: Color? = .appBlack) -> some View {
        if let color = color {
            self
                .font(.system(size: size, weight: weight))
                .foregroundColor(color)
        } else {
            self
                .font(.system(size: size, weight: weight))
        }
    }
    
    @ViewBuilder
    func applyIf(_ condition: Bool, @ViewBuilder _ transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func framed(size: CGSize = .init(width: 22, height: 22)) -> some View {
        self
            .frame(width: size.width, height: size.height)
    }
}

// MARK: - measureSize

private struct SizeMeasuringView: View {
    var onChange: (CGSize) -> Void
    
    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: SizePreferenceKey.self, value: proxy.size)
        }
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func measureSize(_ onChange: @escaping (CGSize) -> Void) -> some View {
        background(SizeMeasuringView(onChange: onChange))
    }
}

