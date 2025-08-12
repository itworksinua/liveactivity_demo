//
//  TokenType.swift
//  Runner
//
//  Created by Dmytro Grytsenko on 12.08.2025.
//

import Foundation

enum TokenType: String, CaseIterable {
    case pushToStart = "pushToStartToken"
    case pushUpdates = "pushTokenUpdates"
    
    var serverKey: String {
        switch self {
        case .pushToStart: "pushToStartToken"
        case .pushUpdates: "refreshActivityToken"
        }
    }
}
