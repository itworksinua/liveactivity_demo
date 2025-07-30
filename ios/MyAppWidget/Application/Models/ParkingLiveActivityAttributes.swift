//
//  ParkingLiveActivityAttributes.swift
//  liveactivityDemo
//
//  Created by Dmytro Grytsenko on 24.06.2025.
//

import ActivityKit
import Foundation

struct ParkingLiveActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        let type: ActivityType
    }
    
    let zoneId: String
    let licensePlate: String
    let labels: Labels
}

extension ParkingLiveActivityAttributes {
    enum ActivityType: Codable, Hashable {
        case reservation(start: Date, end: Date?)
        case active(start: Date, end: Date?)
        
        private enum CodingKeys: String, CodingKey {
            case type
            case start
            case end
        }
        
        private enum StateType: String, Codable {
            case reservation
            case active
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(StateType.self, forKey: .type)
            let start = try container.decode(Date.self, forKey: .start)
            let end = try container.decodeIfPresent(Date.self, forKey: .end)
            
            switch type {
            case .reservation:
                self = .reservation(start: start, end: end)
            case .active:
                self = .active(start: start, end: end)
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case let .reservation(start, end):
                try container.encode(StateType.reservation, forKey: .type)
                try container.encode(start, forKey: .start)
                try container.encodeIfPresent(end, forKey: .end)
            case let .active(start, end):
                try container.encode(StateType.active, forKey: .type)
                try container.encode(start, forKey: .start)
                try container.encodeIfPresent(end, forKey: .end)
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
        case .reservation(let start, _), .active(let start, _): return start
        }
    }
    
    var end: Date? {
        switch self {
        case .reservation(_, let end), .active(_, let end): return end
        }
    }
    
    var isActive: Bool {
        if case .active = self { return true }
        return false
    }
    
    var hasEndDate: Bool {
        switch self {
        case .reservation(_, let end), .active(_, let end):
            return end != nil
        }
    }
}
