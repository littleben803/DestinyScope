//
//  HomeHeroCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct HomeHeroCard: View {
    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("DestinyScope")
                    .font(AppTheme.Typography.pageTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text("东方命理 · 自我探索")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.darkGold)

                Text("基于传统称骨文化和本地模板解读，提供参考性结果、命格诗文和知识学习。")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
