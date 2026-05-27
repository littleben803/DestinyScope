//
//  SettingsView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        AppBackground {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    NavigationLink {
                        AboutView()
                    } label: {
                        settingsRow(
                            title: "关于 DestinyScope",
                            subtitle: "本地传统命理数据与产品说明"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        settingsRow(
                            title: "隐私政策",
                            subtitle: "无账号、无服务端、出生信息不上传"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        DisclaimerView()
                    } label: {
                        settingsRow(
                            title: "免责声明",
                            subtitle: "娱乐、自我探索和传统文化学习参考"
                        )
                    }
                    .buttonStyle(.plain)

                    #if DEBUG
                    NavigationLink {
                        LocalModelDebugView()
                    } label: {
                        settingsRow(
                            title: "本地模型 PoC",
                            subtitle: "Debug-only，当前不加载模型"
                        )
                    }
                    .buttonStyle(.plain)
                    #endif
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("关于")
    }

    private func settingsRow(title: String, subtitle: String) -> some View {
        AppCard {
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text(title)
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(subtitle)
                        .font(AppTheme.Typography.secondary)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
        }
    }
}
