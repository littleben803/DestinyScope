//
//  LocalModelDebugView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

#if DEBUG
import SwiftUI

struct LocalModelDebugView: View {
    @State private var testMessage = "尚未测试"
    @State private var isTesting = false

    private let config = LocalModelDebugConfig.current

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    AppSectionHeader(title: "V1.2 本地模型 PoC")

                    AppCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            infoRow(title: "当前默认模型", value: "未配置")
                            infoRow(title: "推荐模型", value: "Qwen2.5-0.5B-Instruct GGUF 4-bit")
                            infoRow(title: "预期文件名", value: config.expectedModelFileName)
                            infoRow(title: "文件位置", value: config.modelDirectoryDescription)
                        }
                    }

                    AppCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("当前阶段不加载模型，不执行真实推理，也不影响默认 App 输出。模型文件不会提交仓库。")
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)

                            Text("后续阶段 3B 才会评估 llama.cpp 真实加载与性能数据。")
                                .font(AppTheme.Typography.secondary)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                        }
                    }

                    AppPrimaryButton(title: isTesting ? "测试中..." : "测试接口") {
                        runInterfaceTest()
                    }
                    .disabled(isTesting)

                    AppCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("接口测试结果")
                                .font(AppTheme.Typography.sectionTitle)
                                .foregroundColor(AppTheme.Colors.primaryText)

                            Text(testMessage)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("本地模型 PoC")
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

    private func runInterfaceTest() {
        isTesting = true
        testMessage = "测试中..."

        Task {
            let input = TextRefiningInput(
                sourceText: "这是一次 Debug-only 本地模型接口测试。",
                purpose: .general,
                tone: .calm,
                context: ["stage": "V1.2-3A"]
            )

            let message: String
            do {
                let output = try await LocalLlamaTextRefiner(config: config).refine(input)
                message = output.text
            } catch TextRefiningError.localModelNotAvailable {
                message = "本地模型尚未配置。当前阶段仅验证接口骨架，不加载 GGUF 模型。"
            } catch {
                message = (error as? LocalizedError)?.errorDescription ?? "接口测试失败。"
            }

            await MainActor.run {
                testMessage = message
                isTesting = false
            }
        }
    }
}
#endif
