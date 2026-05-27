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
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("本地模型 PoC")
        .onAppear {
            checkModelFiles()
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

    private func formatDuration(_ duration: TimeInterval?) -> String {
        guard let duration else {
            return "未记录"
        }

        return String(format: "%.3f 秒", duration)
    }
}
#endif
