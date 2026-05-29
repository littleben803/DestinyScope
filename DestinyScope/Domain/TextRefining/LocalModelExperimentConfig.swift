//
//  LocalModelExperimentConfig.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import Foundation

struct LocalModelExperimentConfig {
    let featureName: String
    let isAvailableInCurrentBuild: Bool
    let isDefaultEnabled: Bool
    let requiresUserConsent: Bool
    let isProductionDefaultEnabled: Bool
    let descriptionText: String
    let safetyNoticeText: String

    static let current = LocalModelExperimentConfig(
        featureName: "本地模型润色实验",
        isAvailableInCurrentBuild: buildAvailability,
        isDefaultEnabled: false,
        requiresUserConsent: true,
        isProductionDefaultEnabled: false,
        descriptionText: "本功能使用设备端本地模型对已有模板文本做表达润色，不生成新的命理结论，不替代称骨计算和模板规则。",
        safetyNoticeText: "本地模型润色仅供 TestFlight / Debug 内测验证。它不会上传出生信息、命理结果、模型输入输出或历史记录；失败时会回退本地模板文本。"
    )

    private static var buildAvailability: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
