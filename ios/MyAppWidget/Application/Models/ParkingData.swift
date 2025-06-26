//
//  ParkingData.swift
//  liveactivityDemo
//
//  Created by Dmytro Grytsenko on 26.06.2025.
//

import Foundation

struct ParkingData {
    let currentDuration: String
    let remainingTime: String
    let totalDuration: String
    
    private let defaults = UserDefaults(suiteName: "group.com.itworksinua.liveactivity")
    
    init(attributes: LiveActivitiesAppAttributes) {
        currentDuration = defaults?.string(forKey: Self.prefixedKey("current_duration")) ?? "Current Duration"
        remainingTime = defaults?.string(forKey: Self.prefixedKey("remaining_time")) ?? "Remaining Time"
        totalDuration = defaults?.string(forKey: Self.prefixedKey("total_duration")) ?? "Total Duration"
    }
    
    private static func prefixedKey(_ key: String) -> String {
        "live_activity_\(key)"
    }
}
