//
//  LocalModelExperimentAvailability.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import Foundation

struct LocalModelExperimentAvailability {
    let isAvailable: Bool
    let reason: String?

    static func current(config: LocalModelExperimentConfig = .current) -> LocalModelExperimentAvailability {
        guard config.isAvailableInCurrentBuild else {
            return LocalModelExperimentAvailability(
                isAvailable: false,
                reason: "当前构建不开放本地模型润色实验。正式 Release 默认隐藏。"
            )
        }

        // TODO: V1.4 stage 3 adds device tier checks. TestFlight detection also needs a
        // dedicated implementation before exposing this outside DEBUG.
        return LocalModelExperimentAvailability(isAvailable: true, reason: nil)
    }
}
