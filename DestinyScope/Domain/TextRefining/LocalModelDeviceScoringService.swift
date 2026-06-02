//
//  LocalModelDeviceScoringService.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

struct LocalModelDeviceScoringService {
    private let threshold = 75
    private let deviceTierService: DeviceTierService

    init(deviceTierService: DeviceTierService = DeviceTierService()) {
        self.deviceTierService = deviceTierService
    }

    func currentScore(
        modelStatus: LocalModelFileStatus,
        isFrameworkAvailable: Bool
    ) -> LocalModelDeviceScore {
        let identifier = DeviceModelIdentifier.currentIdentifier()
        let isSimulator = DeviceModelIdentifier.isSimulatorIdentifier(identifier)
        let tier = isSimulator ? .tierA : deviceTierService.tier(for: identifier)
        let physicalMemoryGB = Double(ProcessInfo.processInfo.physicalMemory) / 1_073_741_824
        let thermalState = ProcessInfo.processInfo.thermalState
        let isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled

        var score = baseScore(identifier: identifier, tier: tier, isSimulator: isSimulator)
        if physicalMemoryGB >= 8 {
            score += 10
        } else if physicalMemoryGB >= 6 {
            score += 5
        }

        let hardBlockReason: String?
        if isLowPowerMode {
            hardBlockReason = "当前处于低电量模式。"
        } else if thermalState == .serious || thermalState == .critical {
            hardBlockReason = "当前设备温度较高。"
        } else if !modelStatus.isUsable {
            hardBlockReason = modelStatus.reason ?? "未找到内置本地模型。"
        } else if !isFrameworkAvailable {
            hardBlockReason = "llama framework 不可用。"
        } else if !isSimulator && tier == .tierC {
            hardBlockReason = "当前设备性能分级不适合默认启用本地润色。"
        } else if !isSimulator && tier == .unknown {
            hardBlockReason = "当前设备未识别，默认使用模板文本。"
        } else {
            hardBlockReason = nil
        }

        let eligible = hardBlockReason == nil && (isSimulator || score >= threshold)
        let reason: String
        if let hardBlockReason {
            reason = hardBlockReason
        } else if eligible {
            reason = isSimulator ? "模拟器默认启用本地润色。" : "设备评分达标，默认启用本地润色。"
        } else {
            reason = "设备评分低于 \(threshold)，默认使用模板文本。"
        }

        return LocalModelDeviceScore(
            score: score,
            tier: tier,
            identifier: identifier,
            physicalMemoryGB: physicalMemoryGB,
            isSimulator: isSimulator,
            isLowPowerMode: isLowPowerMode,
            thermalStateDescription: thermalState.displayName,
            isEligible: eligible,
            reason: reason,
            timeoutSeconds: timeoutSeconds(score: score, tier: tier, isEligible: eligible)
        )
    }

    private func baseScore(identifier: String, tier: DeviceTier, isSimulator: Bool) -> Int {
        if isSimulator {
            return 100
        }

        if identifier == "iPhone13,1" {
            return 35
        }

        if let iPhoneMajor = iPhoneMajorVersion(from: identifier) {
            switch iPhoneMajor {
            case ...13:
                return 35
            case 14, 15:
                return 70
            case 16:
                return tier == .tierA ? 90 : 80
            case 17...:
                return 95
            default:
                return 50
            }
        }

        switch tier {
        case .tierA:
            return 90
        case .tierB:
            return 70
        case .tierC:
            return 35
        case .unknown:
            return 50
        }
    }

    private func iPhoneMajorVersion(from identifier: String) -> Int? {
        guard identifier.hasPrefix("iPhone") else {
            return nil
        }

        return identifier
            .dropFirst("iPhone".count)
            .split(separator: ",")
            .first
            .flatMap { Int($0) }
    }

    private func timeoutSeconds(score: Int, tier: DeviceTier, isEligible: Bool) -> TimeInterval {
        guard isEligible else {
            return 0
        }

        if score >= 90 || tier == .tierA {
            return 3
        }

        return 5
    }
}

private extension ProcessInfo.ThermalState {
    var displayName: String {
        switch self {
        case .nominal:
            return "nominal"
        case .fair:
            return "fair"
        case .serious:
            return "serious"
        case .critical:
            return "critical"
        @unknown default:
            return "unknown"
        }
    }
}
