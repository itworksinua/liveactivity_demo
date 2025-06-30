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
    let price: ParkingLiveActivityAttributes.Price
    let startDate: Date
    let endDate: Date
    let labels: ParkingLiveActivityAttributes.Labels
}

final class ParkingLiveActivityService {
    static let shared = ParkingLiveActivityService()
    
    private var activity: Activity<ParkingLiveActivityAttributes>?
    
    private init() {}
    
    var isLiveActivityEnabled: Bool {
        ActivityAuthorizationInfo().areActivitiesEnabled
    }
    
    func sync(with model: ParkingLiveActivityModel) {
        guard isLiveActivityEnabled else {
            print("⛔️ Live Activities not available, skipping sync")
            return
        }
        
        Task { [weak self] in
            await self?.performSync(with: model)
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
    
    private func performSync(with model: ParkingLiveActivityModel) async {
        let attributes = makeAttributes(from: model)
        let content = makeContent(with: model.endDate)
        
        restoreActivityIfNeeded(for: model.zoneId)
        
        guard let currentActivity = activity else {
            activity = await start(attributes: attributes, content: content)
            return
        }
        
        switch currentActivity.activityState {
        case .active:
            await update(currentActivity, with: content)
        case .dismissed:
            return
        default:
            activity = await start(attributes: attributes, content: content)
        }
    }
    
    @discardableResult
    private func start(
        attributes: ParkingLiveActivityAttributes,
        content: ActivityContent<ParkingLiveActivityAttributes.ContentState>
    ) async -> Activity<ParkingLiveActivityAttributes>? {
        do {
            let activity = try Activity<ParkingLiveActivityAttributes>.request(
                attributes: attributes,
                content: content
            )
            
            print("✅ Live Activity started: \(activity.id)")
            return activity
        } catch {
            print("❌ Failed to start Live Activity: \(error)")
            return nil
        }
    }
    
    private func update(_ activity: Activity<ParkingLiveActivityAttributes>, with content: ActivityContent<ParkingLiveActivityAttributes.ContentState>) async {
        await activity.update(content)
    }
    
    private func makeAttributes(from model: ParkingLiveActivityModel) -> ParkingLiveActivityAttributes {
        ParkingLiveActivityAttributes(
            zoneId: model.zoneId,
            licensePlate: model.licensePlate,
            price: model.price,
            startDate: model.startDate,
            endDate: model.endDate,
            labels: model.labels
        )
    }
    
    private func makeContent(with staleDate: Date) -> ActivityContent<ParkingLiveActivityAttributes.ContentState> {
        let state = ParkingLiveActivityAttributes.ContentState()
        return ActivityContent(state: state, staleDate: staleDate)
    }
    
    private func existingActivity(for zoneId: String) -> Activity<ParkingLiveActivityAttributes>? {
        Activity<ParkingLiveActivityAttributes>.activities.first { $0.attributes.zoneId == zoneId }
    }
    
    private func restoreActivityIfNeeded(for zoneId: String) {
        guard activity == nil else { return }
        
        activity = existingActivity(for: zoneId)
        
        if let restored = activity {
            print("🔄 Restored existing Live Activity: \(restored.id)")
        }
    }
}
