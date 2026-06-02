//
//  ProductionLocalRefiningCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct ProductionLocalRefiningCard: View {
    let interpretation: FortuneInterpretation
    let insight: LifeWeightInsight

    @State private var output: TextRefiningOutput?
    @State private var isGenerating = false
    @State private var hasAttempted = false
    @State private var elapsedTime: TimeInterval?
    @State private var fallbackReason: String?

    private let inputBuilder = LocalRefiningPreviewInputBuilder()
    private let availability = ProductionLocalAIAvailability.current()

    private var input: TextRefiningInput {
        inputBuilder.build(interpretation: interpretation, insight: insight)
    }

    var body: some View {
        if availability.shouldShowEntry {
            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    AppSectionHeader(title: "本地润色版")

                    Text("设备端生成，只做表达润色，不改变命理结论。模板结果始终保留。")
                        .font(AppTheme.Typography.secondary)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    if isGenerating {
                        ProgressView("正在生成本地润色版...")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }

                    if let output {
                        Text(output.text)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)

                        infoRow(title: "状态", value: output.wasRefined ? "本地润色完成" : "已回退模板")
                        infoRow(title: "engine", value: output.engine)
                        if let elapsedTime {
                            infoRow(title: "耗时", value: String(format: "%.2f 秒", elapsedTime))
                        }

                        if let safetyNotice = output.safetyNotice {
                            Text(safetyNotice)
                                .font(AppTheme.Typography.footnote)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    } else if hasAttempted, let fallbackReason {
                        Text(fallbackReason)
                            .font(AppTheme.Typography.secondary)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .task {
                await autoGenerateIfNeeded()
            }
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Text(title)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .frame(width: 64, alignment: .leading)

            Text(value)
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func autoGenerateIfNeeded() async {
        guard !hasAttempted, !isGenerating else {
            return
        }

        await MainActor.run {
            hasAttempted = true
            isGenerating = true
            fallbackReason = nil
            elapsedTime = nil
        }

        let start = Date()
        do {
            let refined = try await TextRefinerFactory.makeDefaultRefiner().refine(input)
            await MainActor.run {
                output = refined
                elapsedTime = Date().timeIntervalSince(start)
                if !refined.wasRefined {
                    fallbackReason = refined.safetyNotice
                }
                isGenerating = false
            }
        } catch {
            await MainActor.run {
                fallbackReason = "本地润色暂不可用，已保留原始模板文本。"
                elapsedTime = Date().timeIntervalSince(start)
                isGenerating = false
            }
        }
    }
}
