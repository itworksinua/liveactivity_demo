//
//  Date+Extension.swift
//  MyAppWidgetExtension
//
//  Created by Dmytro Grytsenko on 30.07.2025.
//

import Foundation

extension Date {
    enum DateFormat {
        case dateWithDots
        case time
    }
    
    private static let dateWithDotsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.M.yyyy"
        return formatter
    }()
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    func formatted(as format: DateFormat) -> String {
        switch format {
        case .dateWithDots:
            Date.dateWithDotsFormatter.string(from: self)
        case .time:
            Date.timeFormatter.string(from: self)
        }
    }
}
