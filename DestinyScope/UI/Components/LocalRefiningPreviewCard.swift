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
    @State private var isGenerationInFlight = false
    @State private var warningMessage: String?

    private let inputBuilder = LocalRefiningPreviewInputBuilder()
    private let runtimeGuard = LocalModelRuntimeGuard()
    private let failureTracker = LocalModelFailureTracker()

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

                    if let warningMessage {
                        Text(warningMessage)
                            .font(AppTheme.Typography.secondary)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }

                    if let output {
                        outputSection(output)
                    }

                    if let errorMessage = errorMessage ?? state.message {
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
            .disabled(isGenerationInFlight)

            Button("使用原始文本") {
                isCollapsed = true
            }
            .font(AppTheme.Typography.body)
            .foregroundColor(AppTheme.Colors.secondaryText)
            .disabled(isGenerationInFlight)
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
        guard !isGenerationInFlight else {
            return
        }

        let currentAvailability = LocalModelExperimentAvailability.current(settings: settings)
        let runtimeState = runtimeGuard.evaluate(availability: currentAvailability)

        guard runtimeState.canRun, let timeoutSeconds = runtimeState.timeoutSeconds else {
            let error = runtimeState.blockingError ?? .modelUnavailable
            state = .blocked(reason: error.userFriendlyMessage)
            errorMessage = error.userFriendlyMessage
            failureTracker.recordFailure()
            return
        }

        isGenerationInFlight = true
        state = .generating
        output = nil
        errorMessage = nil
        duration = nil
        warningMessage = runtimeState.warningMessage

        Task {
            let startedAt = Date()
            let refiningInput = input

            #if DEBUG
            do {
                let refined = try await refineWithTimeout(
                    input: refiningInput,
                    timeoutSeconds: timeoutSeconds
                )
                let elapsed = Date().timeIntervalSince(startedAt)

                await MainActor.run {
                    output = refined
                    duration = elapsed
                    if refined.wasRefined {
                        state = .success
                        failureTracker.resetOnSuccess()
                    } else {
                        let error: LocalModelRuntimeError = refined.safetyNotice?.contains("安全检查") == true
                            ? .safetyCheckFailed(refined.safetyNotice ?? "")
                            : .generationFailed(refined.safetyNotice ?? "")
                        state = .fallback(reason: error.userFriendlyMessage)
                        errorMessage = error.userFriendlyMessage
                        failureTracker.recordFailure()
                    }
                    isGenerationInFlight = false
                }
            } catch LocalModelRuntimeError.timeout {
                await MainActor.run {
                    state = .timeout
                    duration = Date().timeIntervalSince(startedAt)
                    errorMessage = LocalModelRuntimeError.timeout.userFriendlyMessage
                    failureTracker.recordFailure()
                    // The underlying llama.cpp call may not be immediately cancellable.
                    // Keep the card usable after the UI-level fallback is shown.
                    isGenerationInFlight = false
                }
            } catch {
                await MainActor.run {
                    let runtimeError = (error as? LocalModelRuntimeError) ?? .generationFailed(error.localizedDescription)
                    state = .failed(reason: runtimeError.userFriendlyMessage)
                    duration = Date().timeIntervalSince(startedAt)
                    errorMessage = runtimeError.userFriendlyMessage
                    failureTracker.recordFailure()
                    isGenerationInFlight = false
                }
            }
            #else
            await MainActor.run {
                state = .failed(reason: LocalModelRuntimeError.modelUnavailable.userFriendlyMessage)
                duration = Date().timeIntervalSince(startedAt)
                errorMessage = LocalModelRuntimeError.modelUnavailable.userFriendlyMessage
                failureTracker.recordFailure()
                isGenerationInFlight = false
            }
            #endif
        }
    }

    #if DEBUG
    private func refineWithTimeout(
        input: TextRefiningInput,
        timeoutSeconds: TimeInterval
    ) async throws -> TextRefiningOutput {
        let refiningTask = Task.detached {
            try await TextRefinerFactory
                .makeLocalExperimentRefiner()
                .refine(input)
        }

        let timeoutTask = Task.detached { () -> TextRefiningOutput in
            try await Task.sleep(nanoseconds: UInt64(timeoutSeconds * 1_000_000_000))
            throw LocalModelRuntimeError.timeout
        }

        do {
            let result = try await withThrowingTaskGroup(of: TextRefiningOutput.self) { group in
                group.addTask {
                    try await refiningTask.value
                }

                group.addTask {
                    try await timeoutTask.value
                }

                guard let firstResult = try await group.next() else {
                    throw LocalModelRuntimeError.generationFailed("empty result")
                }

                group.cancelAll()
                return firstResult
            }

            timeoutTask.cancel()
            return result
        } catch {
            refiningTask.cancel()
            timeoutTask.cancel()
            throw error
        }
    }
    #endif
}
