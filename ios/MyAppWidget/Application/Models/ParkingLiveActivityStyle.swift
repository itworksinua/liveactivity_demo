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
    
    var foregroundColor: Color {
        switch self {
        case .light: .appPrimary
        case .dark: .appBackground
        }
    }
}
