//
//  LocalModelRuntimeError.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

enum LocalModelRuntimeError: LocalizedError, Equatable {
    case lowPowerMode
    case thermalStateTooHigh
    case unsupportedDeviceTier
    case modelUnavailable
    case timeout
    case consecutiveFailuresExceeded
    case generationFailed(String)
    case safetyCheckFailed(String)

    var errorDescription: String? {
        userFriendlyMessage
    }

    var userFriendlyMessage: String {
        switch self {
        case .lowPowerMode:
            return "当前处于低电量模式，已保留原始模板文本。"
        case .thermalStateTooHigh:
            return "设备温度较高，已暂停本地润色并保留原始文本。"
        case .unsupportedDeviceTier:
            return "当前设备暂不开放本地润色实验，已保留原始模板文本。"
        case .modelUnavailable:
            return "本地模型暂不可用，已保留原始模板文本。"
        case .timeout:
            return "本地润色超时，已保留原始模板文本。"
        case .consecutiveFailuresExceeded:
            return "本地润色连续失败，已暂时回退到模板文本。"
        case .generationFailed:
            return "本地润色暂不可用，已保留原始模板文本。"
        case .safetyCheckFailed:
            return "模型输出未通过安全检查，已回退到原始文本。"
        }
    }
}
