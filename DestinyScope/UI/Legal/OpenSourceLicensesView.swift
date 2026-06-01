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
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    LegalSummaryCard(
                        title: "开源许可",
                        bodyText: "本页面用于记录 DestinyScope 本地模型实验相关的开源许可草案，不构成法律意见。",
                        highlights: [
                            "当前正式功能仍可在不启用本地模型实验的情况下使用。",
                            "如果未来 App 正式包含模型或框架，会继续补充对应 license / notice。",
                            "进入分发前仍需人工复核具体来源、许可、署名和再分发条件。"
                        ]
                    )

                    ForEach(items) { item in
                        AppCard {
                            AppSectionHeader(title: item.name)

                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                LegalInfoRow(title: "License", value: item.license)
                                LegalInfoRow(title: "来源", value: item.sourceDisplayText, allowsSelection: true)
                                LegalInfoRow(title: "说明", value: item.description)
                            }
                        }
                    }

                    LegalSectionCard(
                        title: "后续要求",
                        bodyText: "如果未来 App 正式包含模型或框架，需要继续补充相应 license / notice，并在发布前人工复核来源、许可、署名、再分发和 App 内分发条件。"
                    )
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("开源许可")
    }
}
