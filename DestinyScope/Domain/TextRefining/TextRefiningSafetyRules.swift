//
//  TextRefiningSafetyRules.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

enum TextRefiningSafetyRules {
    static let defaultRules = [
        "不做绝对预测。",
        "不做医疗、法律、财务、投资、婚恋、职业决策建议。",
        "不写精准预测、改命、化解、避灾、必然发财、寿命疾病预测、投资确定性、婚姻确定性。",
        "模型只能润色表达，不能生成命理计算结论。",
        "不要扩写事实，不要新增结论。",
        "不要重复免责声明，只保留一次安全提示。"
    ]

    static let safetyNotice = "以上内容仅供娱乐、自我探索和传统文化学习参考，不构成现实决策建议。"
}
