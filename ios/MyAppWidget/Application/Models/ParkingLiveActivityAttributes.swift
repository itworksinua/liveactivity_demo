//
//  ParkingLiveActivityAttributes.swift
//  liveactivityDemo
//
//  Created by Dmytro Grytsenko on 24.06.2025.
//

import ActivityKit
import Foundation

struct ParkingLiveActivityAttributes: ActivityAttributes {
    typealias ContentState = ActivityType
    
    let zoneId: String
    let licensePlate: String
    let labels: Labels
}

extension ParkingLiveActivityAttributes {
    enum ActivityType: Codable, Hashable {
        case reservation(start: Date, end: Date?)
        case active(start: Date, end: Date?)
        
        private enum CodingKeys: String, CodingKey {
            case reservation, active
        }
        
        private struct Period: Codable, Hashable {
            let start: Date
            let end: Date?
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let value = try container.decodeIfPresent(Period.self, forKey: .active) {
                self = .active(start: value.start, end: value.end)
            } else if let value = try container.decodeIfPresent(Period.self, forKey: .reservation) {
                self = .reservation(start: value.start, end: value.end)
            } else {
                throw DecodingError.dataCorrupted(
                    .init(codingPath: decoder.codingPath, debugDescription: "Unknown ActivityType")
                )
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            let period: Period
            switch self {
            case let .active(start, end):
                period = Period(start: start, end: end)
                try container.encode(period, forKey: .active)
            case let .reservation(start, end):
                period = Period(start: start, end: end)
                try container.encode(period, forKey: .reservation)
            }
        }
    }
    
    struct Labels: Codable, Hashable {
        let ends: String
        let ended: String
        
        init(
            ends: String = "Ends",
            ended: String = "Ended"
        ) {
            self.ends = ends
            self.ended = ended
        }
    }
}

extension ParkingLiveActivityAttributes.ActivityType {
    var start: Date {
        switch self {
        case .reservation(let start, _), .active(let start, _):
            return start
        }
    }
    
    var end: Date? {
        switch self {
        case .reservation(_, let end), .active(_, let end):
            return end
        }
    }
    
    var isActive: Bool {
        switch self {
        case .active: true
        case .reservation: false
        }
    }
    
    var hasEndDate: Bool {
        return end != nil
    }
}
