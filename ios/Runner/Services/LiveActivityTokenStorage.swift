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
    
    private init() {}
        
    func savePushToStartToken(_ token: Data) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        
        let tokenHex = token.hex
        defaults.set(tokenHex, forKey: TokenKey.pushToStartToken.rawValue)
        print("💾 Saved Push to Start token: \(tokenHex)")
    }
    
    func getPushToStartToken() -> String? {
        UserDefaults(suiteName: suiteName)?.string(forKey: TokenKey.pushToStartToken.rawValue)
    }
    
    func savePushTokenUpdates(_ token: Data) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        
        let tokenHex = token.hex
        defaults.set(tokenHex, forKey: TokenKey.pushTokenUpdates.rawValue)
        print("💾 Saved Push Token Updates: \(tokenHex)")
    }
    
    func getPushTokenUpdates() -> String? {
        UserDefaults(suiteName: suiteName)?.string(forKey: TokenKey.pushTokenUpdates.rawValue)
    }
    
    // MARK: - Convenience Methods
    
    func saveTokens(pushToStart: Data, pushUpdates: Data) {
        savePushToStartToken(pushToStart)
        savePushTokenUpdates(pushUpdates)
    }
    
    func getAllTokens() -> (pushToStart: String?, pushUpdates: String?) {
        return (
            pushToStart: getPushToStartToken(),
            pushUpdates: getPushTokenUpdates()
        )
    }
    
    func clearAllTokens() {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        
        TokenKey.allCases.forEach { key in
            defaults.removeObject(forKey: key.rawValue)
        }
        
        print("🗑️ Cleared all Live Activity tokens")
    }
    
    func clearPushToStartToken() {
        UserDefaults(suiteName: suiteName)?.removeObject(forKey: TokenKey.pushToStartToken.rawValue)
    }
    
    func clearPushTokenUpdates() {
        UserDefaults(suiteName: suiteName)?.removeObject(forKey: TokenKey.pushTokenUpdates.rawValue)
    }
    
    // MARK: - For Server Communication
    
    func getTokensForServer() -> [String: String] {
        var tokens: [String: String] = [:]
        
        if let pushToStartToken = getPushToStartToken() {
            tokens[TokenKey.pushToStartToken.rawValue] = pushToStartToken
        }
        
        if let pushTokenUpdates = getPushTokenUpdates() {
            tokens[TokenKey.pushTokenUpdates.rawValue] = pushTokenUpdates
        }
        
        return tokens
    }
    
    func hasAllTokens() -> Bool {
        return getPushToStartToken() != nil && getPushTokenUpdates() != nil
    }
}

// MARK: - TokenKey

extension LiveActivityTokenStorage {
    private enum TokenKey: String, CaseIterable {
        case pushToStartToken
        case pushTokenUpdates
    }
}


private extension Data {
    var hex: String { map { String(format: "%02x", $0) }.joined() }
}
