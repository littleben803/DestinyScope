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

    @EnvironmentObject private var localizationStore: LocalizationStore

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
                    AppSectionHeader(title: localizationStore.string("result.localRefining.title"))

                    Text(localizationStore.string("result.localRefining.description"))
                        .font(AppTheme.Typography.secondary)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    if isGenerating {
                        ProgressView(localizationStore.string("result.localRefining.generating"))
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }

                    if let output {
                        Text(output.text)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)

                        infoRow(
                            title: localizationStore.string("result.localRefining.status"),
                            value: output.wasRefined
                                ? localizationStore.string("result.localRefining.status.refined")
                                : localizationStore.string("result.localRefining.status.fallback")
                        )
                        infoRow(title: "engine", value: output.engine)
                        if let elapsedTime {
                            infoRow(
                                title: localizationStore.string("result.localRefining.duration"),
                                value: localizationStore.string(
                                    "common.duration.seconds.twoDecimals",
                                    replacements: ["seconds": String(format: "%.2f", elapsedTime)]
                                )
                            )
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
                fallbackReason = localizationStore.string("result.localRefining.fallbackReason")
                elapsedTime = Date().timeIntervalSince(start)
                isGenerating = false
            }
        }
    }
}
