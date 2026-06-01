//
//  LocalModelRuntimeState.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct LocalModelRuntimeState: Equatable {
    let canRun: Bool
    let timeoutSeconds: TimeInterval?
    let warningMessage: String?
    let blockingError: LocalModelRuntimeError?

    static func allowed(
        timeoutSeconds: TimeInterval,
        warningMessage: String? = nil
    ) -> LocalModelRuntimeState {
        LocalModelRuntimeState(
            canRun: true,
            timeoutSeconds: timeoutSeconds,
            warningMessage: warningMessage,
            blockingError: nil
        )
    }

    static func blocked(_ error: LocalModelRuntimeError) -> LocalModelRuntimeState {
        LocalModelRuntimeState(
            canRun: false,
            timeoutSeconds: nil,
            warningMessage: nil,
            blockingError: error
        )
    }
}
