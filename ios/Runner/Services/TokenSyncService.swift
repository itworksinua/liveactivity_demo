//
//  TokenSyncService.swift
//  Runner
//
//  Created by Dmytro Grytsenko on 12.08.2025.
//

import Foundation

final class TokenSyncService {
    static let shared = TokenSyncService()
    
    private var authorization: String?
    private var serverURL: URL?
    
    private init() {}
    
    func configure(authorization: String, url: String) {
        self.authorization = authorization
        self.serverURL = URL(string: url)
        print("🔧 TokenSyncService configured with URL: \(url)")
    }
    
    func syncToken(_ token: String, tokenType: TokenType) {
        guard
            let authorization = authorization,
            let serverURL = serverURL
        else {
            print("⚠️ TokenSyncService not configured. Call configure(authorization:url:) first")
            return
        }
        
        Task {
            await sendTokenToServer(token, tokenType: tokenType, url: serverURL, authorization: authorization)
        }
    }
    
    func syncAllTokens() {
        let tokens = LiveActivityTokenStorage.shared.getAllTokens()
        
        if let pushToStart = tokens.pushToStart {
            syncToken(pushToStart, tokenType: .pushToStart)
        }
        
        if let pushUpdates = tokens.pushUpdates {
            syncToken(pushUpdates, tokenType: .pushUpdates)
        }
    }
    
    private func sendTokenToServer(_ token: String, tokenType: TokenType, url: URL, authorization: String) async {
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
        
        let postData: [String: Any] = [tokenType.serverKey: token]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: [])
        } catch {
            print("❌ Error creating JSON data for \(tokenType.rawValue): \(error)")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("❌ Invalid response or status code for \(tokenType.rawValue) token sync")
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code: \(httpResponse.statusCode)")
                }
                return
            }
            
            print("✅ Successfully synced \(tokenType.rawValue) token to server")
            print("Response: \(String(data: data, encoding: .utf8) ?? "N/A")")
            
        } catch {
            print("❌ Error during \(tokenType.rawValue) token sync: \(error.localizedDescription)")
        }
    }
}
