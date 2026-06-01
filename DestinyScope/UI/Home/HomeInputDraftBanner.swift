//
//  HomeInputDraftBanner.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct HomeInputDraftBanner: View {
    let message: String
    let onClear: () -> Void

    var body: some View {
        AppCard {
            HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                Image(systemName: "arrow.uturn.left.circle")
                    .font(.title3)
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text("已填入待查询资料")
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(message)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Button("清除提示", action: onClear)
                        .font(AppTheme.Typography.footnote.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.cinnabar)
                        .accessibilityLabel("清除历史填入提示")
                        .accessibilityHint("只清除当前提示，不会清除已经填入的出生日期和时辰。")
                }
            }
        }
    }
}
