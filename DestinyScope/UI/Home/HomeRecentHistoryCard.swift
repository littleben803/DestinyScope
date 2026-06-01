//
//  HomeRecentHistoryCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct HomeRecentHistoryCard: View {
    let record: HistoryRecord?

    var body: some View {
        AppCard {
            AppSectionHeader(title: "最近记录")

            if let record {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text(record.title)
                        .font(AppTheme.Typography.body.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(record.createdAtDisplayText)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)

                    Text(record.birthDisplayText)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)

                    Text("总重量：\(record.totalWeightText)")
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.darkGold)

                    Text("可在历史页查看、收藏、置顶或填回首页复查。")
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            } else {
                Text("完成一次查询后，会在本机保存轻量历史记录，方便之后回看。")
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
