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
    let startDate: Date
    var endDate: Date? = nil
    let labels: ParkingLiveActivityAttributes.Labels
}

final class ParkingLiveActivityService {
    static let shared = ParkingLiveActivityService()
    
    private var activity: Activity<ParkingLiveActivityAttributes>?
    private var activityObservationTask: Task<Void, Never>?
    
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
            
            resetActivityState()
            
            print("🧹 Live Activity ended for zone: \(zoneId)")
        }
    }
    
    func endAll() {
        Task { [weak self] in
            guard let self else { return }
            
            for activity in Activity<ParkingLiveActivityAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
                print("🧹 Ended activity: \(activity.id)")
            }
            
            resetActivityState()
        }
    }
    
    private func resetActivityState() {
        activity = nil
        cancelObservation()
    }
    
    private func performSync(with model: ParkingLiveActivityModel) async {
        let attributes = makeAttributes(from: model)
        let delayedStaleDate = model.endDate?.addingTimeInterval(1)
        let content = makeContent(with: delayedStaleDate)
        
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
                content: content,
                pushType: .token
            )
            
            observeLiveActivity(activity)
            
            print("✅ Live Activity started: \(activity.id)")
            return activity
        } catch {
            print("❌ Failed to start Live Activity: \(error)")
            return nil
        }
    }
    
    private func update(_ activity: Activity<ParkingLiveActivityAttributes>, with content: ActivityContent<ParkingLiveActivityAttributes.ContentState>) async {
        await activity.update(content)
        print("✅ Live Activity updated: \(activity.id)")
    }
    
    private func makeAttributes(from model: ParkingLiveActivityModel) -> ParkingLiveActivityAttributes {
        ParkingLiveActivityAttributes(
            zoneId: model.zoneId,
            licensePlate: model.licensePlate,
            startDate: model.startDate,
            endDate: model.endDate,
            labels: model.labels
        )
    }
    
    private func makeContent(with staleDate: Date?) -> ActivityContent<ParkingLiveActivityAttributes.ContentState> {
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
    
    private func observeLiveActivity(_ activity: Activity<ParkingLiveActivityAttributes>) {
        activityObservationTask = Task { @MainActor [weak self] in
            guard let self else { return }
            
            defer { cancelObservation() }
            
            await withTaskGroup(of: Void.self) { group in
                group.addTask { @MainActor [weak self] in
                    for await state in activity.activityStateUpdates {
                        if state == .stale {
                            self?.end(for: activity.attributes.zoneId)
                            print("🛑 Live Activity ended due to stale state: \(activity.id)")
                            break
                        }
                    }
                }
                
                group.addTask {
                    for await tokenData in activity.pushTokenUpdates {
                        LiveActivityTokenStorage.shared.save(token: tokenData)
                    }
                }
            }
        }
    }
    
    private func cancelObservation() {
        activityObservationTask?.cancel()
        activityObservationTask = nil
    }
}
