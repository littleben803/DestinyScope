//
//  AboutView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    AppCard {
                        Text("DestinyScope")
                            .font(AppTheme.Typography.pageTitle)
                            .foregroundColor(AppTheme.Colors.primaryText)

                        Text("东方命理、传统文化学习与自我探索工具。")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)

                        Text("当前能力基于本地传统命理数据、本地模板和设备端文本润色生成结果，出生信息仅在设备端处理。")
                            .font(AppTheme.Typography.secondary)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    AppCard {
                        AppSectionHeader(title: "当前能力")

                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            bullet("出生日期和时辰仅用于设备端本地计算。")
                            bullet("称骨结果、命格洞察、命理问答和知识库均可离线使用。")
                            bullet("历史记录仅保存在本设备，可在历史页删除。")
                            bullet("本地模型润色仅用于对已有模板文本做表达润色，不生成新的命理结论。")
                        }
                    }

                    AppCard {
                        AppSectionHeader(title: "使用边界")

                        Text("内容仅供娱乐、自我探索和传统文化学习参考，不构成现实决策建议。")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    SettingsSectionCard(title: "使用帮助") {
                        legalLink(
                            title: "使用说明",
                            subtitle: "查看首次使用说明、隐私和结果边界",
                            accessibilityHint: "打开 DestinyScope 使用说明页面。"
                        ) {
                            OnboardingView(isReviewMode: true)
                        }
                    }

                    SettingsSectionCard(title: "法律与隐私") {
                        legalLink(
                            title: "隐私政策",
                            subtitle: "出生信息仅在设备端处理",
                            accessibilityHint: "打开隐私政策页面。"
                        ) {
                            PrivacyPolicyView()
                        }

                        Divider()
                            .background(AppTheme.Colors.divider)

                        legalLink(
                            title: "免责声明",
                            subtitle: "仅供娱乐、自我探索和传统文化学习参考",
                            accessibilityHint: "打开免责声明页面。"
                        ) {
                            DisclaimerView()
                        }

                        Divider()
                            .background(AppTheme.Colors.divider)

                        legalLink(
                            title: "开源许可",
                            subtitle: "查看本地模型和开源组件许可信息",
                            accessibilityHint: "打开开源许可页面。"
                        ) {
                            OpenSourceLicensesView()
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("关于")
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Text("•")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.darkGold)

            Text(text)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func legalLink<Destination: View>(
        title: String,
        subtitle: String,
        accessibilityHint: String,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink {
            destination()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(title)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(subtitle)
                        .font(AppTheme.Typography.footnote)
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
