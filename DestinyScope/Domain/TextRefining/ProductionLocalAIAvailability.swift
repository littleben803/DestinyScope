//
//  ProductionLocalAIAvailability.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

struct ProductionLocalAIAvailability: Equatable {
    let shouldEnableByDefault: Bool
    let shouldShowEntry: Bool
    let shouldAutoRefine: Bool
    let fallbackReason: String?
    let timeoutSeconds: TimeInterval
    let modelFileStatus: LocalModelFileStatus
    let deviceScore: LocalModelDeviceScore

    static func current(
        modelResolver: BundledLocalModelResolver = BundledLocalModelResolver(),
        scoringService: LocalModelDeviceScoringService = LocalModelDeviceScoringService()
    ) -> ProductionLocalAIAvailability {
        let modelStatus = modelResolver.resolveModelFileStatus()
        let deviceScore = scoringService.currentScore(
            modelStatus: modelStatus,
            isFrameworkAvailable: LlamaCppSession.isFrameworkAvailable
        )

        let shouldEnable = deviceScore.isEligible
        return ProductionLocalAIAvailability(
            shouldEnableByDefault: shouldEnable,
            shouldShowEntry: shouldEnable,
            shouldAutoRefine: shouldEnable,
            fallbackReason: shouldEnable ? nil : deviceScore.reason,
            timeoutSeconds: deviceScore.timeoutSeconds,
            modelFileStatus: modelStatus,
            deviceScore: deviceScore
        )
    }
}
