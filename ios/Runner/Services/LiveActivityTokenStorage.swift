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
        defaults.set(tokenHex, forKey: TokenType.pushToStart.rawValue)
        print("💾 Saved Push to Start token: \(tokenHex)")
        
        TokenSyncService.shared.syncToken(tokenHex, tokenType: .pushToStart)
    }
    
    func getPushToStartToken() -> String? {
        UserDefaults(suiteName: suiteName)?.string(forKey: TokenType.pushToStart.rawValue)
    }
    
    func savePushTokenUpdates(_ token: Data) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        
        let tokenHex = token.hex
        defaults.set(tokenHex, forKey: TokenType.pushUpdates.rawValue)
        print("💾 Saved Push Token Updates: \(tokenHex)")
        
        TokenSyncService.shared.syncToken(tokenHex, tokenType: .pushUpdates)
    }
    
    func getPushTokenUpdates() -> String? {
        UserDefaults(suiteName: suiteName)?.string(forKey: TokenType.pushUpdates.rawValue)
    }
    
    func getAllTokens() -> (pushToStart: String?, pushUpdates: String?) {
        return (
            pushToStart: getPushToStartToken(),
            pushUpdates: getPushTokenUpdates()
        )
    }
}

private extension Data {
    var hex: String { map { String(format: "%02x", $0) }.joined() }
}
