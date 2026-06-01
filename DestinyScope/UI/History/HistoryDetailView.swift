//
//  HistoryDetailView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct HistoryDetailView: View {
    let record: HistoryRecord

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    summaryCard
                    poemCard
                    if !record.tags.isEmpty {
                        tagsCard
                    }
                    HistoryLocalNoticeView()
                    lightweightRecordNotice
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("历史详情")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var summaryCard: some View {
        AppCard {
            Text(record.title)
                .font(AppTheme.Typography.pageTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Text("查询时间：\(record.createdAtDisplayText)")
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)

            Divider()
                .background(AppTheme.Colors.divider)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text(record.birthDisplayText)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text(record.lunarBirthday)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                Text("总重量：\(record.totalWeightText)")
                    .font(AppTheme.Typography.body.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.darkGold)
            }
        }
    }

    private var poemCard: some View {
        AppCard {
            AppSectionHeader(title: "称骨诗文")
            Text(record.poem)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var tagsCard: some View {
        AppCard {
            AppSectionHeader(title: "标签")
            HistoryTagGrid(tags: record.tags)
        }
    }

    private var lightweightRecordNotice: some View {
        AppCard {
            Text("这是一次历史查询的轻量记录，完整报告请重新查询生成。")
                .font(AppTheme.Typography.footnote)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
