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
            description: "用于本地模型推理支持。V1.8 起作为生产候选依赖接入时，需要保留 license / notice，并在发布前完成最终人工复核。"
        ),
        OpenSourceLicenseItem(
            id: "ggml-gguf",
            name: "ggml / GGUF",
            sourceURLs: ["llama.cpp 项目相关组件"],
            license: "以 llama.cpp 仓库 LICENSE 为准",
            description: "用于本地 GGUF 模型推理支持。若额外引入独立组件或二进制产物，需要逐项补充许可说明。"
        ),
        OpenSourceLicenseItem(
            id: "qwen25-05b",
            name: "Qwen2.5-0.5B-Instruct / GGUF",
            sourceURLs: [
                "https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct",
                "https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF"
            ],
            license: "Apache 2.0，最终以模型仓库为准",
            description: "V1.8 作为内置本地模型生产候选。进入 TestFlight 或 App Store 分发前仍需人工确认具体文件来源、LICENSE / NOTICE、商业使用、再分发和 App 内分发条件。"
        )
    ]

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    LegalSummaryCard(
                        title: "开源许可",
                        bodyText: "本页面用于记录 DestinyScope 本地模型相关的开源许可草案，不构成法律意见。",
                        highlights: [
                            "本地模型只用于设备端文本表达润色。",
                            "如果 App 正式包含模型或框架，会继续补充对应 license / notice。",
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
                        bodyText: "如果 App 正式包含模型或框架，需要继续补充相应 license / notice，并在发布前人工复核来源、许可、署名、再分发和 App 内分发条件。"
                    )
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("开源许可")
    }
}
