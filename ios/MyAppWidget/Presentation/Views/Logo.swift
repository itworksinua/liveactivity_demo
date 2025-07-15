//
//  Logo.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 16.07.2025.
//

import SwiftUI

struct Logo: View {
    var size: CGSize = .init(width: 22, height: 22)
    
    var body: some View {
        Image(.logo)
            .resizable()
            .framed(size: size)
    }
}

#Preview {
    Logo()
}
