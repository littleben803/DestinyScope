//
//  FortuneQuestionView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import SwiftUI

struct FortuneQuestionView: View {
    let result: LifeWeightResult
    let interpretation: FortuneInterpretation
    let insight: LifeWeightInsight

    @State private var selectedQuestionID: String?
    @State private var answer: FortuneAnswer?

    private let answerer = TemplateFortuneQuestionAnswerer()

    private let questions: [FortuneQuestion] = [
        FortuneQuestion(id: "career", title: "我适合什么职业？", intent: .career),
        FortuneQuestion(id: "wealth", title: "我的财运特点是什么？", intent: .wealth),
        FortuneQuestion(id: "personality", title: "我的性格倾向是什么？", intent: .personality),
        FortuneQuestion(id: "relationship", title: "关系中需要注意什么？", intent: .relationship),
        FortuneQuestion(id: "daily_advice", title: "今天给我一句建议", intent: .dailyAdvice)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            AppSectionHeader(title: "命理问答")

            Text("选择一个预设问题，基于本次结果生成本地模板回答。")
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)

            VStack(spacing: AppTheme.Spacing.sm) {
                ForEach(questions) { question in
                    Button {
                        select(question)
                    } label: {
                        HStack {
                            Text(question.title)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            Spacer()
                            Image(systemName: selectedQuestionID == question.id ? "checkmark.circle.fill" : "chevron.right")
                                .font(AppTheme.Typography.secondary)
                                .foregroundColor(AppTheme.Colors.cinnabar)
                        }
                        .padding(AppTheme.Spacing.md)
                        .background(
                            selectedQuestionID == question.id
                                ? AppTheme.Colors.secondaryBackground
                                : AppTheme.Colors.cardBackground
                        )
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous)
                                .stroke(AppTheme.Colors.divider.opacity(0.6), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            if let answer {
                Divider()
                    .background(AppTheme.Colors.divider)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text(answer.questionTitle)
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(answer.answer)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(answer.safetyNotice)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func select(_ question: FortuneQuestion) {
        selectedQuestionID = question.id
        answer = answerer.answer(
            question: question,
            result: result,
            interpretation: interpretation,
            insight: insight
        )
    }
}
