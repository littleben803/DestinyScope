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
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("关于")
    }
}
