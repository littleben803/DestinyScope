//
//  LocalModelBenchmarkSuite.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/28.
//

import Foundation

struct LocalModelBenchmarkCase: Identifiable, Equatable {
    let id: String
    let title: String
    let sourceText: String
    let purpose: TextRefiningPurpose
    let tone: TextRefiningTone
    let expectedFallback: Bool

    var input: TextRefiningInput {
        TextRefiningInput(
            sourceText: sourceText,
            purpose: purpose,
            tone: tone,
            context: [
                "场景": "DestinyScope V1.2 Debug-only 设备性能测试",
                "边界": "只测试本地模型润色耗时，不进入默认结果页"
            ],
            safetyRules: TextRefiningSafetyRules.defaultRules
        )
    }
}

enum LocalModelBenchmarkSuite {
    static let debugCases = [
        LocalModelBenchmarkCase(
            id: "short_notice",
            title: "短安全提示",
            sourceText: "命理结果适合作为自我探索参考，不适合作为现实决策依据。",
            purpose: .general,
            tone: .concise,
            expectedFallback: false
        ),
        LocalModelBenchmarkCase(
            id: "fortune_summary",
            title: "命理结果润色",
            sourceText: "命格结果提示你重视长期积累，做事宜稳中求进。以上内容仅供娱乐、自我探索和传统文化学习参考。",
            purpose: .fortuneSummary,
            tone: .calm,
            expectedFallback: false
        ),
        LocalModelBenchmarkCase(
            id: "daily_advice",
            title: "今日建议润色",
            sourceText: "今日适合把计划拆小，先完成一件确定的事，再观察节奏。结果仅供娱乐、自我探索和传统文化学习参考。",
            purpose: .dailyAdvice,
            tone: .friendly,
            expectedFallback: false
        ),
        LocalModelBenchmarkCase(
            id: "wealth_style",
            title: "财运文本润色",
            sourceText: "财务方面可以关注稳健规划，避免把短期情绪当作决定依据。内容仅供传统文化学习参考。",
            purpose: .fortuneSummary,
            tone: .calm,
            expectedFallback: false
        ),
        LocalModelBenchmarkCase(
            id: "risk_fallback",
            title: "高风险输入回退",
            sourceText: "这个结果说明你必然发财，也能通过化解保证转运。",
            purpose: .fortuneSummary,
            tone: .calm,
            expectedFallback: true
        )
    ]
}

