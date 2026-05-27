//
//  LocalModelDebugView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

#if DEBUG
import SwiftUI

struct LocalModelDebugView: View {
    @State private var modelStatuses: [LocalModelFileStatus] = []
    @State private var fileCheckTime: TimeInterval?
    @State private var loadTime: TimeInterval?
    @State private var generateTime: TimeInterval?
    @State private var outputText = "尚未生成"
    @State private var errorMessage: String?
    @State private var isRunning = false
    @State private var refinedText = "尚未润色"
    @State private var refineEngine = "未运行"
    @State private var refineWasRefined = false
    @State private var refineSafetyNotice = "未记录"
    @State private var refineTime: TimeInterval?
    @State private var refineErrorMessage: String?
    @State private var didFallbackToTemplate = false
    @State private var selectedTestCase = TextRefiningTestSuite.debugCases[0]
    @State private var safetyCheckSummary = "未运行"
    @State private var matchedRiskTerms = "无"

    private let config = LocalModelDebugConfig.current

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    AppSectionHeader(title: "V1.2 本地模型 PoC")

                    AppCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            infoRow(title: "当前默认输出", value: "TemplateTextRefiner")
                            infoRow(title: "推荐模型", value: "Qwen2.5-0.5B-Instruct GGUF 4-bit")
                            infoRow(title: "llama.xcframework", value: config.llamaFrameworkExists() ? "已配置" : "未找到")
                            infoRow(title: "framework 路径", value: config.llamaFrameworkPath)
                            infoRow(title: "主路径", value: config.primaryModelPath)
                            infoRow(title: "备用路径", value: config.fallbackModelPath)
                            infoRow(title: "文件位置", value: config.modelDirectoryDescription)
                        }
                    }

                    AppCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("当前实验入口只在 Debug 下可见，不影响默认 App 输出。模型文件不会提交仓库，也不会复制进 App Bundle。")
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)

                            Text("如果 llama.cpp framework 尚未接入，加载测试会显示明确错误并保持 App 可编译。")
                                .font(AppTheme.Typography.secondary)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                        }
                    }

                    AppPrimaryButton(title: "检查模型文件") {
                        checkModelFiles()
                    }
                    .disabled(isRunning)

                    AppPrimaryButton(title: isRunning ? "加载中..." : "加载并生成测试文本") {
                        runGenerationTest()
                    }
                    .disabled(isRunning)

                    statusCard

                    refiningCard
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("本地模型 PoC")
        .onAppear {
            checkModelFiles()
        }
    }

    private var refiningCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("TextRefining 润色测试")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text("安全测试样例")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                ForEach(TextRefiningTestSuite.debugCases) { testCase in
                    Button {
                        selectedTestCase = testCase
                        resetRefiningState()
                    } label: {
                        HStack {
                            Text(testCase.title)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            Spacer()
                            if selectedTestCase.id == testCase.id {
                                Text("当前")
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.Colors.darkGold)
                            }
                        }
                        .padding(.vertical, AppTheme.Spacing.xs)
                    }
                    .buttonStyle(.plain)
                }

                infoRow(title: "测试名称", value: selectedTestCase.title)
                infoRow(title: "sourceText", value: selectedTestCase.sourceText)

                AppPrimaryButton(title: isRunning ? "润色中..." : "调用 TextRefining.refine") {
                    runTextRefiningTest()
                }
                .disabled(isRunning)

                infoRow(title: "refinedText", value: refinedText)
                infoRow(title: "engine", value: refineEngine)
                infoRow(title: "wasRefined", value: refineWasRefined ? "true" : "false")
                infoRow(title: "safetyNotice", value: refineSafetyNotice)
                infoRow(title: "耗时", value: formatDuration(refineTime))
                infoRow(title: "回退状态", value: didFallbackToTemplate ? "已回退到模板文本" : "未回退")
                infoRow(title: "safety check", value: safetyCheckSummary)
                infoRow(title: "风险原因", value: matchedRiskTerms)

                if let refineErrorMessage {
                    Text("错误信息")
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(refineErrorMessage)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.cinnabar)
                }
            }
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(title)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)

            Text(value)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
        }
    }

    private var statusCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("模型文件状态")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                if modelStatuses.isEmpty {
                    Text("尚未检查。")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                } else {
                    ForEach(modelStatuses) { status in
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text(status.displayPath)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)

                            Text(status.exists ? "存在，大小 \(status.sizeDescription)" : "未找到")
                                .font(AppTheme.Typography.secondary)
                                .foregroundColor(status.exists ? AppTheme.Colors.darkGold : AppTheme.Colors.secondaryText)
                        }
                    }
                }

                infoRow(title: "文件检查耗时", value: formatDuration(fileCheckTime))
                infoRow(title: "加载耗时", value: formatDuration(loadTime))
                infoRow(title: "生成耗时", value: formatDuration(generateTime))

                Text("输出文本")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text(outputText)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                if let errorMessage {
                    Text("错误信息")
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(errorMessage)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.cinnabar)
                }
            }
        }
    }

    private func checkModelFiles() {
        let start = CFAbsoluteTimeGetCurrent()
        modelStatuses = config.modelFileStatuses()
        fileCheckTime = CFAbsoluteTimeGetCurrent() - start
    }

    private func runGenerationTest() {
        isRunning = true
        errorMessage = nil
        outputText = "测试中..."
        loadTime = nil
        generateTime = nil
        checkModelFiles()

        Task {
            let output: String
            let errorText: String?
            let measuredLoadTime: TimeInterval?
            let measuredGenerateTime: TimeInterval?

            do {
                let result = try LocalLlamaTextRefiner(config: config).runDebugGeneration()
                output = result.output
                errorText = nil
                measuredLoadTime = result.loadTime
                measuredGenerateTime = result.generateTime
            } catch TextRefiningError.localModelNotAvailable {
                output = "未生成"
                errorText = "本地模型尚未配置。"
                measuredLoadTime = nil
                measuredGenerateTime = nil
            } catch {
                output = "未生成"
                errorText = (error as? LocalizedError)?.errorDescription ?? "接口测试失败。"
                measuredLoadTime = nil
                measuredGenerateTime = nil
            }

            await MainActor.run {
                outputText = output
                errorMessage = errorText
                loadTime = measuredLoadTime
                generateTime = measuredGenerateTime
                isRunning = false
            }
        }
    }

    private func runTextRefiningTest() {
        isRunning = true
        refineErrorMessage = nil
        refinedText = "测试中..."
        refineEngine = "运行中"
        refineWasRefined = false
        refineSafetyNotice = "未记录"
        refineTime = nil
        didFallbackToTemplate = false
        safetyCheckSummary = "未运行"
        matchedRiskTerms = "无"

        let input = TextRefiningInput(
            sourceText: selectedTestCase.sourceText,
            purpose: selectedTestCase.purpose,
            tone: selectedTestCase.tone,
            context: [
                "场景": "DestinyScope V1.2 Debug-only TextRefining PoC",
                "边界": "只能润色既有模板文本，不进入默认结果页"
            ],
            safetyRules: TextRefiningSafetyRules.defaultRules
        )

        Task {
            let start = CFAbsoluteTimeGetCurrent()
            let output: TextRefiningOutput
            let errorText: String?
            let fallbackUsed: Bool
            let safetyResult: TextRefiningSafetyCheckResult

            do {
                output = try await TextRefinerFactory.makeDebugLocalLlamaRefiner().refine(input)
                safetyResult = TextRefiningSafetyChecker().check(output.text, sourceText: input.sourceText)
                errorText = output.engine.contains("fallback") ? output.safetyNotice : nil
                fallbackUsed = output.engine.contains("fallback")
            } catch {
                output = (try? await TextRefinerFactory.makeTemplateRefiner().refine(input)) ?? TextRefiningOutput(
                    text: input.sourceText,
                    wasRefined: false,
                    engine: "template",
                    safetyNotice: TextRefiningSafetyRules.safetyNotice
                )
                errorText = (error as? LocalizedError)?.errorDescription ?? "TextRefining 测试失败，已回退到模板文本。"
                fallbackUsed = true
                safetyResult = TextRefiningSafetyChecker().check(output.text, sourceText: input.sourceText)
            }

            let elapsed = CFAbsoluteTimeGetCurrent() - start

            await MainActor.run {
                refinedText = output.text
                refineEngine = output.engine
                refineWasRefined = output.wasRefined
                refineSafetyNotice = output.safetyNotice ?? "未记录"
                refineTime = elapsed
                refineErrorMessage = errorText
                didFallbackToTemplate = fallbackUsed
                safetyCheckSummary = safetyResult.isPassed ? "通过" : "未通过"
                matchedRiskTerms = safetyResult.reasonText
                isRunning = false
            }
        }
    }

    private func resetRefiningState() {
        refinedText = "尚未润色"
        refineEngine = "未运行"
        refineWasRefined = false
        refineSafetyNotice = "未记录"
        refineTime = nil
        refineErrorMessage = nil
        didFallbackToTemplate = false
        safetyCheckSummary = "未运行"
        matchedRiskTerms = "无"
    }

    private func formatDuration(_ duration: TimeInterval?) -> String {
        guard let duration else {
            return "未记录"
        }

        return String(format: "%.3f 秒", duration)
    }
}
#endif
