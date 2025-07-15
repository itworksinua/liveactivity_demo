//
//  ParkingLiveActivityAttributes.swift
//  liveactivityDemo
//
//  Created by Dmytro Grytsenko on 24.06.2025.
//

import ActivityKit
import Foundation

struct ParkingLiveActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {}
    
    let zoneId: String
    let licensePlate: String
    let startDate: Date
    let endDate: Date?
    let labels: Labels
}

extension ParkingLiveActivityAttributes {
    struct Labels: Codable, Hashable {
        let ends: String
        
        init(
            ends: String = "Ends"
        ) {
            self.ends = ends
        }
    }
}
