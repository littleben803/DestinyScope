//
//  OpenSourceLicensesView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct OpenSourceLicensesView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    private var items: [OpenSourceLicenseItem] {
        [
            OpenSourceLicenseItem(
                id: "llama-cpp",
                name: "llama.cpp",
                sourceURLs: ["https://github.com/ggml-org/llama.cpp"],
                license: "MIT License",
                sha256: nil,
                usageDescription: localizationStore.string("legal.openSource.llama.usage"),
                copyrightText: localizationStore.string("legal.openSource.llama.copyright"),
                noticeText: localizationStore.string("legal.openSource.llama.notice")
            ),
            OpenSourceLicenseItem(
                id: "ggml-gguf",
                name: "ggml / GGUF",
                sourceURLs: [localizationStore.string("legal.openSource.gguf.source")],
                license: localizationStore.string("legal.openSource.gguf.license"),
                sha256: nil,
                usageDescription: localizationStore.string("legal.openSource.gguf.usage"),
                copyrightText: localizationStore.string("legal.openSource.gguf.copyright"),
                noticeText: localizationStore.string("legal.openSource.gguf.notice")
            ),
            OpenSourceLicenseItem(
                id: "qwen25-05b-base",
                name: "Qwen2.5-0.5B-Instruct",
                sourceURLs: [
                    "https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct"
                ],
                license: "Apache License 2.0",
                sha256: nil,
                usageDescription: localizationStore.string("legal.openSource.qwenBase.usage"),
                copyrightText: localizationStore.string("legal.openSource.qwenBase.copyright"),
                noticeText: localizationStore.string("legal.openSource.qwenBase.notice")
            ),
            OpenSourceLicenseItem(
                id: "qwen25-05b-gguf-repo",
                name: "Qwen2.5-0.5B-Instruct-GGUF",
                sourceURLs: [
                    "https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF"
                ],
                license: "Apache License 2.0",
                sha256: nil,
                usageDescription: localizationStore.string("legal.openSource.qwenGGUF.usage"),
                copyrightText: localizationStore.string("legal.openSource.qwenGGUF.copyright"),
                noticeText: localizationStore.string("legal.openSource.qwenGGUF.notice")
            ),
            OpenSourceLicenseItem(
                id: "qwen25-05b-q4-k-m",
                name: "qwen2.5-0.5b-instruct-q4_k_m.gguf",
                sourceURLs: [
                    "DestinyScope/Resources/Models/qwen2.5-0.5b-instruct-q4_k_m.gguf"
                ],
                license: "Apache License 2.0",
                sha256: "74a4da8c9fdbcd15bd1f6d01d621410d31c6fc00986f5eb687824e7b93d7a9db",
                usageDescription: localizationStore.string("legal.openSource.bundledModel.usage"),
                copyrightText: localizationStore.string("legal.openSource.bundledModel.copyright"),
                noticeText: localizationStore.string("legal.openSource.bundledModel.notice")
            )
        ]
    }

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    LegalSummaryCard(
                        title: localizationStore.string("legal.openSource.summary.title"),
                        bodyText: localizationStore.string("legal.openSource.summary.body"),
                        highlights: (0...2).map {
                            localizationStore.string(L10nID("legal.openSource.highlight.\($0)"))
                        }
                    )

                    ForEach(items) { item in
                        AppCard {
                            AppSectionHeader(title: item.name)

                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                LegalInfoRow(
                                    title: localizationStore.string(.legalInfoLicense),
                                    value: item.license
                                )
                                LegalInfoRow(
                                    title: localizationStore.string(.legalInfoSource),
                                    value: item.sourceDisplayText,
                                    allowsSelection: true
                                )
                                LegalInfoRow(
                                    title: localizationStore.string(.legalInfoUsage),
                                    value: item.usageDescription
                                )
                                if let sha256 = item.sha256 {
                                    LegalInfoRow(title: "SHA-256", value: sha256, allowsSelection: true)
                                }
                                LegalInfoRow(
                                    title: localizationStore.string(.legalInfoCopyrightNotice),
                                    value: item.copyrightText
                                )
                                LegalInfoRow(
                                    title: localizationStore.string(.legalInfoNotice),
                                    value: item.noticeText
                                )
                            }
                        }
                    }

                    LegalSectionCard(
                        title: localizationStore.string("legal.openSource.additional.title"),
                        bodyText: localizationStore.string("legal.openSource.additional.body")
                    )
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(localizationStore.string(.legalOpenSourceNavigationTitle))
    }
}
