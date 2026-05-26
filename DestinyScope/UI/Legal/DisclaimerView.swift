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
            "内容来源",
            "DestinyScope 的内容基于传统命理文化、本地命理数据和本地模板生成，用于展示传统文化中的概念、诗文和参考性解读。"
        ),
        (
            "参考边界",
            "所有结果仅供娱乐、自我探索和传统文化学习参考，不代表对未来或现实结果的确定性预测。"
        ),
        (
            "非专业建议",
            "应用内容不构成医疗、法律、财务、投资、婚恋、职业等现实决策建议，也不能替代专业人士的判断。"
        ),
        (
            "高风险内容限制",
            "DestinyScope 不提供健康、寿命、疾病预测，不提供投资收益或财务结果的确定性判断，也不提供婚姻关系的确定性判断。"
        ),
        (
            "重大决策",
            "用户不应仅依据 App 结果做重大现实决策。如遇到健康、法律、财务、婚恋、职业等现实问题，应咨询相应领域的专业人士。"
        )
    ]

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    AppCard {
                        Text("免责声明")
                            .font(AppTheme.Typography.pageTitle)
                            .foregroundColor(AppTheme.Colors.primaryText)

                        Text("请以理性、轻松和学习传统文化的方式看待应用结果。")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }

                    ForEach(sections, id: \.title) { section in
                        AppCard {
                            AppSectionHeader(title: section.title)
                            Text(section.body)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("免责声明")
    }
}
