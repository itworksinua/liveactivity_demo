//
//  ParkingLiveActivityService.swift
//  liveactivityDemo
//
//  Created by Dmytro Grytsenko on 24.06.2025.
//

import ActivityKit
import Foundation

struct ParkingLiveActivityModel {
    let zoneId: String
    let licensePlate: String
    let price: Double
    let startDate: Date
    let endDate: Date
}

final class ParkingLiveActivityService {
    static let shared = ParkingLiveActivityService()
    
    private var activity: Activity<LiveActivitiesAppAttributes>?
    
    private init() {}
    
    func sync(with model: ParkingLiveActivityModel) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("⛔️ Live Activities not available, skipping sync")
            return
        }
        
        let attributes = LiveActivitiesAppAttributes(
            zoneId: model.zoneId,
            licensePlate: model.licensePlate,
            price: model.price,
            startDate: model.startDate,
            endDate: model.endDate
        )
        
        let content = ActivityContent(state: LiveActivitiesAppAttributes.ContentState(), staleDate: nil)
        
        Task { [weak self] in
            guard let self else { return }
            
            self.restoreActivityIfNeeded(for: model.zoneId)
            
            if let activity, activity.activityState == .active {
                await self.update(activity, with: content)
            } else {
                await self.start(attributes: attributes, content: content)
            }
        }
    }
    
    func end(for zoneId: String) {
        restoreActivityIfNeeded(for: zoneId)
        
        Task { [weak self] in
            guard let self else { return }
            
            await activity?.end(nil, dismissalPolicy: .immediate)
            activity = nil
        }
    }
    
    func endAll() {
        Task { [weak self] in
            for activity in Activity<LiveActivitiesAppAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            self?.activity = nil
        }
    }
    
    private func update(_ activity: Activity<LiveActivitiesAppAttributes>, with content: ActivityContent<LiveActivitiesAppAttributes.ContentState>) async {
        await activity.update(content)
    }
    
    private func start(attributes: LiveActivitiesAppAttributes, content: ActivityContent<LiveActivitiesAppAttributes.ContentState>) async {
        do {
            let newActivity = try Activity<LiveActivitiesAppAttributes>.request(attributes: attributes, content: content)
            activity = newActivity
            print("✅ Live Activity started: \(newActivity.id)")
        } catch {
            print("❌ Failed to start Live Activity: \(error)")
        }
    }
    
    private func restoreActivityIfNeeded(for zoneId: String) {
        guard activity == nil else { return }
        
        activity = Activity<LiveActivitiesAppAttributes>.activities.first(where: {
            $0.attributes.zoneId == zoneId
        })
        
        if let restored = activity {
            print("🔄 Restored existing Live Activity: \(restored.id)")
        }
    }
}
