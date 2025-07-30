//
//  LiveActivityTokenStorage.swift
//  Runner
//
//  Created by Dmytro Grytsenko on 23.07.2025.
//

import Foundation

final class LiveActivityTokenStorage {
    static let shared = LiveActivityTokenStorage()
    
    private let suiteName = "group.com.itworksinua.liveactivity"
    private let tokenKey = "liveActivityPushToken"
    
    private init() {}
    
    func save(token: Data) {
        let tokenHex = token.map { String(format: "%02x", $0) }.joined()
        
        if let defaults = UserDefaults(suiteName: suiteName) {
            defaults.set(tokenHex, forKey: tokenKey)
            print("💾 Saved Live Activity token: \(tokenHex)")
        }
    }
    
    func getToken() -> String? {
        UserDefaults(suiteName: suiteName)?.string(forKey: tokenKey)
    }
    
    func clear() {
        UserDefaults(suiteName: suiteName)?.removeObject(forKey: tokenKey)
    }
}
