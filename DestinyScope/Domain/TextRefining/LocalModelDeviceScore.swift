//
//  LocalModelDeviceScore.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

struct LocalModelDeviceScore: Equatable {
    let score: Int
    let tier: DeviceTier
    let identifier: String
    let physicalMemoryGB: Double
    let isSimulator: Bool
    let isLowPowerMode: Bool
    let thermalStateDescription: String
    let isEligible: Bool
    let reason: String
    let timeoutSeconds: TimeInterval
}
