//
//  HomeHeroCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct HomeHeroCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text("DestinyScope")
                .font(AppTheme.Typography.pageTitle)
                .foregroundColor(AppTheme.Colors.primaryText)

            Text("东方命理 · 自我探索")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.darkGold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
