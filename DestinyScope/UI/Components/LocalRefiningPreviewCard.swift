//
//  LocalRefiningPreviewCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import SwiftUI

struct LocalRefiningPreviewCard: View {
    let interpretation: FortuneInterpretation
    let insight: LifeWeightInsight

    @StateObject private var settings = LocalModelExperimentSettings()
    @State private var state: LocalRefiningPreviewState = .idle
    @State private var output: TextRefiningOutput?
    @State private var duration: TimeInterval?
    @State private var errorMessage: String?
    @State private var isCollapsed = false

    private let inputBuilder = LocalRefiningPreviewInputBuilder()

    private var availability: LocalModelExperimentAvailability {
        LocalModelExperimentAvailability.current(settings: settings)
    }

    private var input: TextRefiningInput {
        inputBuilder.build(interpretation: interpretation, insight: insight)
    }

    private var shouldShowCard: Bool {
        availability.isAvailable && settings.isExperimentEnabled && !isCollapsed
    }

    var body: some View {
        if shouldShowCard {
            AppCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    AppSectionHeader(title: "本地润色预览")

                    Text("使用设备端本地模型对已有模板文本做表达润色，不生成新的命理结论。")
                        .font(AppTheme.Typography.secondary)
                        .foregroundColor(AppTheme.Colors.secondaryText)

                    originalSummarySection

                    if state == .generating {
                        ProgressView("正在生成润色版...")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }

                    if let output {
                        outputSection(output)
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(AppTheme.Typography.secondary)
                            .foregroundColor(AppTheme.Colors.cinnabar)
                    }

                    controls
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        } else {
            EmptyView()
        }
    }

    private var originalSummarySection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text("原始文本摘要")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)

            Text(input.sourceText)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineLimit(6)
        }
    }

    private func outputSection(_ output: TextRefiningOutput) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(state == .success ? "润色结果" : "回退文本")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)

            Text(output.text)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)

            infoRow(title: "状态", value: state.displayName)
            infoRow(title: "engine", value: output.engine)
            infoRow(title: "wasRefined", value: output.wasRefined ? "true" : "false")
            infoRow(title: "耗时", value: duration.map { String(format: "%.3f 秒", $0) } ?? "未记录")

            if let safetyNotice = output.safetyNotice {
                Text(safetyNotice)
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
        }
    }

    private var controls: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            AppPrimaryButton(title: state == .idle ? "生成润色版" : "重新生成") {
                generatePreview()
            }
            .disabled(state == .generating)

            Button("使用原始文本") {
                isCollapsed = true
            }
            .font(AppTheme.Typography.body)
            .foregroundColor(AppTheme.Colors.secondaryText)
            .disabled(state == .generating)
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Text(title)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .frame(width: 84, alignment: .leading)

            Text(value)
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.primaryText)
        }
    }

    private func generatePreview() {
        guard state != .generating else {
            return
        }

        guard LocalModelExperimentAvailability.current(settings: settings).isAvailable else {
            state = .failed
            errorMessage = "本地润色暂不可用，已保留原始模板文本。"
            return
        }

        state = .generating
        output = nil
        errorMessage = nil
        duration = nil

        Task {
            let startedAt = Date()
            let refiningInput = input

            #if DEBUG
            do {
                let refined = try await TextRefinerFactory
                    .makeLocalExperimentRefiner()
                    .refine(refiningInput)
                let elapsed = Date().timeIntervalSince(startedAt)

                await MainActor.run {
                    output = refined
                    duration = elapsed
                    if refined.wasRefined {
                        state = .success
                    } else {
                        state = .fallback
                        errorMessage = refined.safetyNotice?.contains("安全检查") == true
                            ? "模型输出未通过安全检查，已回退到原始文本。"
                            : "本地润色暂不可用，已保留原始模板文本。"
                    }
                }
            } catch {
                await MainActor.run {
                    state = .failed
                    duration = Date().timeIntervalSince(startedAt)
                    errorMessage = "本地润色暂不可用，已保留原始模板文本。"
                }
            }
            #else
            await MainActor.run {
                state = .failed
                duration = Date().timeIntervalSince(startedAt)
                errorMessage = "本地润色暂不可用，已保留原始模板文本。"
            }
            #endif
        }
    }
}
