//
//  ParkingLiveActivityAttributes.swift
//  liveactivityDemo
//
//  Created by Dmytro Grytsenko on 24.06.2025.
//

import ActivityKit
import Foundation

struct ParkingLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {}
    
    let zoneId: String
    let licensePlate: String
    let price: Double
    let startDate: Date
    let endDate: Date
    let labels: Labels
}

extension ParkingLiveActivityAttributes {
    struct Labels: Codable, Hashable {
        let currentDuration: String
        let remainingTime: String
        let totalDuration: String
        
        init(
            currentDuration: String = "Current Duration",
            remainingTime: String = "Remaining Time",
            totalDuration: String = "Total Duration"
        ) {
            self.currentDuration = currentDuration
            self.remainingTime = remainingTime
            self.totalDuration = totalDuration
        }
    }
}
