//
//  LocalModelRuntimeGuard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct LocalModelRuntimeGuard {
    private let timeoutPolicy: LocalModelTimeoutPolicy
    private let failureTracker: LocalModelFailureTracker

    init(
        timeoutPolicy: LocalModelTimeoutPolicy = LocalModelTimeoutPolicy(),
        failureTracker: LocalModelFailureTracker = LocalModelFailureTracker()
    ) {
        self.timeoutPolicy = timeoutPolicy
        self.failureTracker = failureTracker
    }

    func evaluate(availability: LocalModelExperimentAvailability) -> LocalModelRuntimeState {
        guard availability.isAvailable else {
            if !availability.isDeviceAllowed {
                return .blocked(.unsupportedDeviceTier)
            }

            if !availability.isModelFileUsable {
                return .blocked(.modelUnavailable)
            }

            return .blocked(.modelUnavailable)
        }

        guard !failureTracker.shouldBlockTemporarily() else {
            return .blocked(.consecutiveFailuresExceeded)
        }

        guard !ProcessInfo.processInfo.isLowPowerModeEnabled else {
            return .blocked(.lowPowerMode)
        }

        let thermalState = ProcessInfo.processInfo.thermalState
        guard thermalState != .serious && thermalState != .critical else {
            return .blocked(.thermalStateTooHigh)
        }

        guard availability.deviceTier.isLocalModelExperimentAllowed || isDebugSimulator(availability) else {
            return .blocked(.unsupportedDeviceTier)
        }

        let isSimulator = DeviceModelIdentifier.isSimulatorIdentifier(availability.deviceIdentifier)
        guard let timeout = timeoutPolicy.timeoutSeconds(
            for: availability.deviceTier,
            isSimulator: isSimulator
        ), timeout > 0 else {
            return .blocked(.unsupportedDeviceTier)
        }

        let warning: String?
        if thermalState == .fair {
            warning = "当前设备温度略高，本地润色可能较慢。"
        } else if isSimulator {
            warning = "Simulator 仅用于 Debug 测试，不代表真机性能。"
        } else {
            warning = nil
        }

        return .allowed(timeoutSeconds: timeout, warningMessage: warning)
    }

    private func isDebugSimulator(_ availability: LocalModelExperimentAvailability) -> Bool {
        #if DEBUG
        return DeviceModelIdentifier.isSimulatorIdentifier(availability.deviceIdentifier)
        #else
        return false
        #endif
    }
}
