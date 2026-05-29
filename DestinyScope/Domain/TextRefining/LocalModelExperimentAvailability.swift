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
    let deviceIdentifier: String
    let deviceTier: DeviceTier
    let timeoutSeconds: TimeInterval?
    let isBuildAvailable: Bool
    let isDeviceAllowed: Bool
    let hasAcceptedNotice: Bool

    static func current(
        settings: LocalModelExperimentSettings? = nil,
        config: LocalModelExperimentConfig = .current,
        deviceTierService: DeviceTierService = DeviceTierService()
    ) -> LocalModelExperimentAvailability {
        let deviceIdentifier = DeviceModelIdentifier.currentIdentifier()
        let deviceTier = deviceTierService.tier(for: deviceIdentifier)
        let isSimulator = DeviceModelIdentifier.isSimulatorIdentifier(deviceIdentifier)
        let isDeviceAllowed = deviceTier.isLocalModelExperimentAllowed || debugAllowsSimulator(isSimulator)
        let hasAcceptedNotice = settings?.hasAcceptedExperimentNotice ?? !config.requiresUserConsent

        guard config.isAvailableInCurrentBuild else {
            return LocalModelExperimentAvailability(
                isAvailable: false,
                reason: "当前构建不开放本地模型润色实验。正式 Release 默认隐藏。",
                deviceIdentifier: deviceIdentifier,
                deviceTier: deviceTier,
                timeoutSeconds: nil,
                isBuildAvailable: false,
                isDeviceAllowed: isDeviceAllowed,
                hasAcceptedNotice: hasAcceptedNotice
            )
        }

        guard isDeviceAllowed else {
            return LocalModelExperimentAvailability(
                isAvailable: false,
                reason: "\(deviceTier.displayName)：\(deviceTier.userFacingNotice)",
                deviceIdentifier: deviceIdentifier,
                deviceTier: deviceTier,
                timeoutSeconds: nil,
                isBuildAvailable: true,
                isDeviceAllowed: false,
                hasAcceptedNotice: hasAcceptedNotice
            )
        }

        guard hasAcceptedNotice else {
            return LocalModelExperimentAvailability(
                isAvailable: false,
                reason: "请先确认实验说明后再开启本地模型润色实验。",
                deviceIdentifier: deviceIdentifier,
                deviceTier: deviceTier,
                timeoutSeconds: timeoutSeconds(for: deviceTier, isSimulator: isSimulator),
                isBuildAvailable: true,
                isDeviceAllowed: true,
                hasAcceptedNotice: false
            )
        }

        return LocalModelExperimentAvailability(
            isAvailable: true,
            reason: isSimulator ? "Simulator 仅用于 Debug 测试，不代表真机性能。" : nil,
            deviceIdentifier: deviceIdentifier,
            deviceTier: deviceTier,
            timeoutSeconds: timeoutSeconds(for: deviceTier, isSimulator: isSimulator),
            isBuildAvailable: true,
            isDeviceAllowed: true,
            hasAcceptedNotice: true
        )
    }

    private static func debugAllowsSimulator(_ isSimulator: Bool) -> Bool {
        #if DEBUG
        return isSimulator
        #else
        return false
        #endif
    }

    private static func timeoutSeconds(for tier: DeviceTier, isSimulator: Bool) -> TimeInterval? {
        if isSimulator {
            return 3
        }
        return tier.defaultTimeoutSeconds
    }
}
