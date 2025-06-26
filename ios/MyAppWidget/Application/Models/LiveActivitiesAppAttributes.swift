//
//  ParkingLiveActivityAttributes.swift
//  liveactivityDemo
//
//  Created by Dmytro Grytsenko on 24.06.2025.
//

import ActivityKit
import Foundation

struct LiveActivitiesAppAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {}
    
    let zoneId: String
    let licensePlate: String
    let price: Double
    let startDate: Date
    let endDate: Date
}
