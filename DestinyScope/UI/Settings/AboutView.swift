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
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    AppCard {
                        Text("DestinyScope")
                            .font(AppTheme.Typography.pageTitle)
                            .foregroundColor(AppTheme.Colors.primaryText)

                        Text("本应用基于本地传统命理数据生成结果，出生信息仅在设备端处理。")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)

                        Text("内容仅供娱乐、自我探索和传统文化学习参考。")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }

                    AppCard {
                        AppSectionHeader(title: "法律与隐私")

                        NavigationLink {
                            PrivacyPolicyView()
                        } label: {
                            legalRow(title: "隐私政策", subtitle: "出生信息仅在设备端处理")
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .background(AppTheme.Colors.divider)

                        NavigationLink {
                            DisclaimerView()
                        } label: {
                            legalRow(title: "免责声明", subtitle: "仅供娱乐、自我探索和传统文化学习参考")
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .background(AppTheme.Colors.divider)

                        NavigationLink {
                            OpenSourceLicensesView()
                        } label: {
                            legalRow(title: "开源许可", subtitle: "本地模型实验相关许可与 notice 草案")
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("关于")
    }

    private func legalRow(title: String, subtitle: String) -> some View {
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
}
