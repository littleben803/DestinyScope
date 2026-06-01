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
                    SettingsSectionCard(
                        title: "应用信息",
                        subtitle: "了解 DestinyScope 的定位、当前能力和本地处理原则。"
                    ) {
                        settingsLink(
                            title: "关于 DestinyScope",
                            subtitle: "传统文化、自我探索和本地优先",
                            accessibilityHint: "打开关于 DestinyScope 页面。"
                        ) {
                            AboutView()
                        }

                        Divider()
                            .background(AppTheme.Colors.divider)

                        settingsLink(
                            title: "使用说明",
                            subtitle: "查看首次使用说明、隐私和结果边界",
                            accessibilityHint: "打开 DestinyScope 使用说明页面。"
                        ) {
                            OnboardingView(isReviewMode: true)
                        }
                    }

                    SettingsSectionCard(
                        title: "隐私与安全",
                        subtitle: "查看数据处理边界、使用免责声明和开源许可说明。"
                    ) {
                        settingsLink(
                            title: "隐私政策",
                            subtitle: "无账号、无服务端、出生信息不上传",
                            accessibilityHint: "打开隐私政策页面。"
                        ) {
                            PrivacyPolicyView()
                        }

                        Divider()
                            .background(AppTheme.Colors.divider)

                        settingsLink(
                            title: "免责声明",
                            subtitle: "娱乐、自我探索和传统文化学习参考",
                            accessibilityHint: "打开免责声明页面。"
                        ) {
                            DisclaimerView()
                        }

                        Divider()
                            .background(AppTheme.Colors.divider)

                        settingsLink(
                            title: "开源许可",
                            subtitle: "本地模型实验相关 license / notice 草案",
                            accessibilityHint: "打开开源许可页面。"
                        ) {
                            OpenSourceLicensesView()
                        }
                    }

                    #if DEBUG
                    SettingsSectionCard(
                        title: "实验功能",
                        subtitle: "仅用于 Debug/TestFlight 内测；默认关闭，不影响正式结果。"
                    ) {
                        settingsLink(
                            title: "本地模型润色实验",
                            subtitle: "只对已有模板文本做表达润色，不生成新的命理结论",
                            accessibilityHint: "打开本地模型润色实验设置页面。"
                        ) {
                            LocalModelExperimentSettingsView()
                        }

                        Divider()
                            .background(AppTheme.Colors.divider)

                        settingsLink(
                            title: "本地模型 PoC",
                            subtitle: "Debug-only，本地 GGUF 加载测试",
                            accessibilityHint: "打开开发者本地模型 PoC 调试页面。"
                        ) {
                            LocalModelDebugView()
                        }
                    }
                    #endif
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("设置")
    }

    private func settingsLink<Destination: View>(
        title: String,
        subtitle: String,
        accessibilityHint: String,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink {
            destination()
        } label: {
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
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityHint(accessibilityHint)
    }
}
