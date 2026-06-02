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
            sha256: nil,
            usageDescription: "用于在设备端运行本地 GGUF 模型。",
            copyrightText: "Copyright notices and license terms are provided by the llama.cpp project.",
            noticeText: "DestinyScope 使用 llama.cpp 支持设备端本地文本润色，不接入服务端或模型下载。"
        ),
        OpenSourceLicenseItem(
            id: "ggml-gguf",
            name: "ggml / GGUF",
            sourceURLs: ["llama.cpp 项目相关组件"],
            license: "以 llama.cpp 仓库 LICENSE 为准",
            sha256: nil,
            usageDescription: "用于本地模型推理和 GGUF 模型格式支持。",
            copyrightText: "Related copyright notices follow the llama.cpp and ggml project materials.",
            noticeText: "GGUF 格式用于在设备端读取和运行 App 内置本地模型文件。"
        ),
        OpenSourceLicenseItem(
            id: "qwen25-05b-base",
            name: "Qwen2.5-0.5B-Instruct",
            sourceURLs: [
                "https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct"
            ],
            license: "Apache License 2.0",
            sha256: nil,
            usageDescription: "用于设备端本地文本润色能力。模型仅用于对已有模板文本做表达润色，不生成新的命理结论。",
            copyrightText: "Copyright notices and license terms are provided by the Qwen model repository.",
            noticeText: "DestinyScope 不以该模型生成新的命理结论，不改变称骨计算结果。"
        ),
        OpenSourceLicenseItem(
            id: "qwen25-05b-gguf-repo",
            name: "Qwen2.5-0.5B-Instruct-GGUF",
            sourceURLs: [
                "https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF"
            ],
            license: "Apache License 2.0",
            sha256: nil,
            usageDescription: "作为 App 内置 GGUF 格式本地模型文件的来源说明。",
            copyrightText: "Copyright notices and license terms are provided by the Qwen GGUF model repository.",
            noticeText: "该 GGUF 模型文件用于设备端文本润色。"
        ),
        OpenSourceLicenseItem(
            id: "qwen25-05b-q4-k-m",
            name: "qwen2.5-0.5b-instruct-q4_k_m.gguf",
            sourceURLs: [
                "DestinyScope/Resources/Models/qwen2.5-0.5b-instruct-q4_k_m.gguf"
            ],
            license: "Apache License 2.0",
            sha256: "74a4da8c9fdbcd15bd1f6d01d621410d31c6fc00986f5eb687824e7b93d7a9db",
            usageDescription: "App 内置的 GGUF 格式本地模型文件，用于设备端文本润色。",
            copyrightText: "Copyright notices and license terms follow the Qwen2.5-0.5B-Instruct and Qwen GGUF model repositories.",
            noticeText: "模型仅在设备端读取；失败或不可用时，App 会回退到本地模板文本。"
        )
    ]

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    LegalSummaryCard(
                        title: "开源许可",
                        bodyText: "DestinyScope 使用以下开源项目和模型组件。相关许可信息在本页面列出。",
                        highlights: [
                            "本地模型只用于设备端文本表达润色。",
                            "本地润色不生成新的命理结论。",
                            "模型输入和输出不上传。"
                        ]
                    )

                    ForEach(items) { item in
                        AppCard {
                            AppSectionHeader(title: item.name)

                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                LegalInfoRow(title: "License", value: item.license)
                                LegalInfoRow(title: "来源", value: item.sourceDisplayText, allowsSelection: true)
                                LegalInfoRow(title: "用途", value: item.usageDescription)
                                if let sha256 = item.sha256 {
                                    LegalInfoRow(title: "SHA-256", value: sha256, allowsSelection: true)
                                }
                                LegalInfoRow(title: "Copyright / Notice", value: item.copyrightText)
                                LegalInfoRow(title: "说明", value: item.noticeText)
                            }
                        }
                    }

                    LegalSectionCard(
                        title: "补充说明",
                        bodyText: "本页面列出当前版本使用的开源组件和模型组件。后续如果更换模型、框架、量化文件或新增二进制组件，许可信息会随版本更新。"
                    )
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("开源许可")
    }
}
