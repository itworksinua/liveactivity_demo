//
//  ParkingLiveActivityAttributes.swift
//  liveactivityDemo
//
//  Created by Dmytro Grytsenko on 24.06.2025.
//

import ActivityKit
import Foundation

struct ParkingLiveActivityAttributes: ActivityAttributes {
    typealias ContentState = State
    
    let zoneId: String
    let licensePlate: String
    let labels: Labels
}

extension ParkingLiveActivityAttributes {
    enum State: Codable, Hashable {
        case reservation(start: Date, end: Date? = nil)
        case active(start: Date, end: Date? = nil)
    }
    
    struct Labels: Codable, Hashable {
        let start: String
        let ends: String
        let ended: String
        let parkingStarts: String
        
        init(
            start: String = "Start",
            ends: String = "Ends",
            ended: String = "Ended",
            parkingStarts: String = "Parking starts"
        ) {
            self.start = start
            self.ends = ends
            self.ended = ended
            self.parkingStarts = parkingStarts
        }
    }
}

extension ParkingLiveActivityAttributes.State {
    private enum CodingKeys: String, CodingKey {
        case reservation, active
    }
    
    private struct Period: Codable, Hashable {
        let start: TimeInterval
        let end: TimeInterval?
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try container.decodeIfPresent(Period.self, forKey: .active) {
            self = .active(
                start: Date(timeIntervalSince1970: value.start),
                end: value.end.map { Date(timeIntervalSince1970: $0) }
            )
        } else if let value = try container.decodeIfPresent(Period.self, forKey: .reservation) {
            self = .reservation(
                start: Date(timeIntervalSince1970: value.start),
                end: value.end.map { Date(timeIntervalSince1970: $0) }
            )
        } else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath, debugDescription: "Unknown State")
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let period: Period
        switch self {
        case let .active(start, end):
            period = Period(
                start: start.timeIntervalSince1970,
                end: end?.timeIntervalSince1970
            )
            try container.encode(period, forKey: .active)
        case let .reservation(start, end):
            period = Period(
                start: start.timeIntervalSince1970,
                end: end?.timeIntervalSince1970
            )
            try container.encode(period, forKey: .reservation)
        }
    }
}

extension ParkingLiveActivityAttributes.State {
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
        end != nil
    }
}
