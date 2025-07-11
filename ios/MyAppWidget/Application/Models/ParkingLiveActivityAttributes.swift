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
    let price: Price
    let startDate: Date
    let endDate: Date
    let labels: Labels
}

extension ParkingLiveActivityAttributes {
    struct Price: Codable, Hashable {
        let amount: Double
        let currencySymbol: String
    }
    
    struct Labels: Codable, Hashable {
        let currentDuration: String
        let remainingTime: String
        let totalDuration: String
        let ended: String
        let parkingEndedTitle: String
        let parkingEndedSubtitle: String
        
        init(
            currentDuration: String = "Current Duration",
            remainingTime: String = "Remaining Time",
            totalDuration: String = "Total Duration",
            ended: String = "Ended",
            parkingEndedTitle: String = "Parking is ended",
            parkingEndedSubtitle: String = "Thanks for using our service"
        ) {
            self.currentDuration = currentDuration
            self.remainingTime = remainingTime
            self.totalDuration = totalDuration
            self.ended = ended
            self.parkingEndedTitle = parkingEndedTitle
            self.parkingEndedSubtitle = parkingEndedSubtitle
        }
    }
}
