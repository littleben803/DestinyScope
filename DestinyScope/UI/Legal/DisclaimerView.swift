//
//  DisclaimerView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct DisclaimerView: View {
    private let sections: [(title: String, body: String)] = [
        (
            "传统文化与自我探索",
            "DestinyScope 的内容基于传统命理文化、本地命理数据和本地模板生成，用于展示传统文化中的概念、诗文和参考性解读。"
        ),
        (
            "使用边界",
            "所有结果仅供娱乐、自我探索和传统文化学习参考，不代表对未来或现实结果的确定性预测。"
        ),
        (
            "非专业建议",
            "应用内容不构成医疗、法律、财务、投资、婚恋、职业等现实决策建议，也不能替代专业人士的判断。"
        ),
        (
            "健康、寿命与疾病",
            "DestinyScope 不提供健康、寿命或疾病方面的预测，也不应作为医疗相关判断依据。涉及现实健康问题时，请咨询相应专业人士。"
        ),
        (
            "财务、投资与职业",
            "DestinyScope 不提供投资收益、财务结果或职业选择的确定性判断。涉及现实财务、投资或职业问题时，请结合专业意见和自身情况判断。"
        ),
        (
            "婚恋关系",
            "DestinyScope 不提供婚姻或关系结果的确定性判断。关系中的沟通、选择和现实处境需要由当事人结合实际情况处理。"
        ),
        (
            "现实结果承诺",
            "DestinyScope 不提供改命、化解、避灾、转运、保证发财或其他现实结果承诺。应用内容只能作为传统文化和自我探索参考，不能作为现实行动的保证或依据。"
        ),
        (
            "本地模型润色",
            "如果启用本地模型润色，该能力只改变已有模板文本的表达方式，不改变命理结论，也不替代本地规则和模板。"
        ),
        (
            "重大决策",
            "用户不应仅依据 App 结果做重大现实决策。如遇到健康、法律、财务、婚恋、职业等现实问题，应咨询相应领域的专业人士。"
        )
    ]

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    LegalSummaryCard(
                        title: "免责声明",
                        bodyText: "请以理性、轻松和学习传统文化的方式看待应用结果。",
                        highlights: [
                            "结果仅供娱乐、自我探索和传统文化学习参考。",
                            "内容不构成医疗、法律、财务、投资、婚恋或职业决策建议。",
                            "本地模型润色只改变表达，不改变命理结论。"
                        ]
                    )

                    ForEach(sections, id: \.title) { section in
                        LegalSectionCard(title: section.title, bodyText: section.body)
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("免责声明")
    }
}
