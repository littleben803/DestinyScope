//
//  LocalModelTimeoutPolicy.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct LocalModelTimeoutPolicy {
    func timeoutSeconds(
        for tier: DeviceTier,
        isSimulator: Bool
    ) -> TimeInterval? {
        if isSimulator {
            return 5
        }

        return tier.defaultTimeoutSeconds
    }
}
