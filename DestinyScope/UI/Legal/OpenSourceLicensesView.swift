//
//  OpenSourceLicensesView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct OpenSourceLicensesView: View {
    private let items: [OpenSourceLicenseItem] = [
        OpenSourceLicenseItem(
            id: "llama-cpp",
            name: "llama.cpp",
            sourceURLs: ["https://github.com/ggml-org/llama.cpp"],
            license: "MIT License",
            description: "用于本地模型 Debug/TestFlight 实验路径。若未来随 App 分发 framework，需要保留 license / notice。"
        ),
        OpenSourceLicenseItem(
            id: "ggml-gguf",
            name: "ggml / GGUF",
            sourceURLs: ["llama.cpp 项目相关组件"],
            license: "以 llama.cpp 仓库 LICENSE 为准",
            description: "用于本地 GGUF 模型推理支持。若未来额外引入独立组件或二进制产物，需要逐项补充许可说明。"
        ),
        OpenSourceLicenseItem(
            id: "qwen25-05b",
            name: "Qwen2.5-0.5B-Instruct / GGUF",
            sourceURLs: [
                "https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct",
                "https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF"
            ],
            license: "Apache 2.0，最终以模型仓库为准",
            description: "当前仅用于本地模型实验验证；进入 TestFlight 或 App Store 分发前仍需人工确认具体文件来源、LICENSE / NOTICE、商业使用、再分发和 App 内分发条件。"
        )
    ]

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    AppCard {
                        Text("开源许可")
                            .font(AppTheme.Typography.pageTitle)
                            .foregroundColor(AppTheme.Colors.primaryText)

                        Text("本页面用于记录 DestinyScope 本地模型实验相关的开源许可草案，不构成法律意见。当前正式功能仍可在不启用本地模型实验的情况下使用。")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }

                    ForEach(items) { item in
                        AppCard {
                            AppSectionHeader(title: item.name)

                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                labeledText(title: "License", body: item.license)

                                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                                    Text("来源")
                                        .font(AppTheme.Typography.secondary)
                                        .foregroundColor(AppTheme.Colors.secondaryText)

                                    ForEach(item.sourceURLs, id: \.self) { url in
                                        Text(url)
                                            .font(AppTheme.Typography.footnote)
                                            .foregroundColor(AppTheme.Colors.primaryText)
                                            .textSelection(.enabled)
                                    }
                                }

                                labeledText(title: "说明", body: item.description)
                            }
                        }
                    }

                    AppCard {
                        AppSectionHeader(title: "后续要求")
                        Text("如果未来 App 正式包含模型或框架，需要继续补充相应 license / notice，并在发布前人工复核来源、许可、署名、再分发和 App 内分发条件。")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("开源许可")
    }

    private func labeledText(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(title)
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)

            Text(body)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
        }
    }
}
