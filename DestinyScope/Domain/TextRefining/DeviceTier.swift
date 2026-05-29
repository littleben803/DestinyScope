//
//  DeviceTier.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import Foundation

enum DeviceTier: String {
    case tierA
    case tierB
    case tierC
    case unknown

    var displayName: String {
        switch self {
        case .tierA:
            return "Tier A"
        case .tierB:
            return "Tier B"
        case .tierC:
            return "Tier C"
        case .unknown:
            return "Unknown"
        }
    }

    var description: String {
        switch self {
        case .tierA:
            return "高性能设备，可进入本地模型润色 TestFlight 实验。"
        case .tierB:
            return "谨慎启用设备，可能较慢或耗电，需要用户手动开启。"
        case .tierC:
            return "默认禁用设备，继续使用本地模板文本。"
        case .unknown:
            return "未识别设备，默认不开放本地模型实验。"
        }
    }

    var isLocalModelExperimentAllowed: Bool {
        switch self {
        case .tierA, .tierB:
            return true
        case .tierC, .unknown:
            return false
        }
    }

    var defaultTimeoutSeconds: TimeInterval? {
        switch self {
        case .tierA:
            return 3
        case .tierB:
            return 5
        case .tierC, .unknown:
            return nil
        }
    }

    var userFacingNotice: String {
        switch self {
        case .tierA:
            return "当前设备适合进行短文本本地润色实验，但功能仍默认关闭。"
        case .tierB:
            return "当前设备可谨慎测试本地润色，可能较慢或增加耗电。"
        case .tierC:
            return "当前设备不建议启用本地润色实验，系统将保持模板输出。"
        case .unknown:
            return "当前设备未被识别，为避免性能和稳定性风险，默认不开放实验。"
        }
    }
}
