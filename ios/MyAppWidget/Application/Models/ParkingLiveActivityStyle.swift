//
//  ParkingLiveActivityStyle.swift
//  Runner
//
//  Created by Dmytro Grytsenko on 27.06.2025.
//

import SwiftUI

enum ParkingLiveActivityStyle {
    case light
    case dark
    
    var isDark: Bool { self == .dark }
    
    var foregroundColor: Color {
        switch self {
        case .light: .appBlack
        case .dark: .appWhite
        }
    }
    
    var accentColor: Color {
        switch self {
        case .light: .appBlue
        case .dark: .appPurpleLight
        }
    }
}
