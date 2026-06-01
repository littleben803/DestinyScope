//
//  HistoryRecordActionBar.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct HistoryRecordActionBar: View {
    let isFavorite: Bool
    let isPinned: Bool
    let onToggleFavorite: () -> Void
    let onTogglePinned: () -> Void
    let onReuseInput: () -> Void

    var body: some View {
        AppCard {
            AppSectionHeader(title: "记录操作")

            Text("这些操作只影响本机历史记录状态。填入首页不会自动查询，也不会生成新的历史记录。")
                .font(AppTheme.Typography.footnote)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: AppTheme.Spacing.sm) {
                actionButton(
                    title: isFavorite ? "取消收藏" : "收藏记录",
                    systemImageName: isFavorite ? "star.slash" : "star",
                    action: onToggleFavorite
                )

                actionButton(
                    title: isPinned ? "取消置顶" : "置顶记录",
                    systemImageName: isPinned ? "pin.slash" : "pin",
                    action: onTogglePinned
                )

                actionButton(
                    title: "填入首页重新查询",
                    systemImageName: "arrowshape.turn.up.left",
                    action: onReuseInput
                )
            }
        }
    }

    private func actionButton(
        title: String,
        systemImageName: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: systemImageName)
                    .frame(width: 20)
                Text(title)
                Spacer()
            }
            .font(AppTheme.Typography.body.weight(.semibold))
            .foregroundColor(AppTheme.Colors.cinnabar)
            .padding(.vertical, AppTheme.Spacing.sm)
            .padding(.horizontal, AppTheme.Spacing.md)
            .background(AppTheme.Colors.secondaryBackground.opacity(0.45))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.button, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint(accessibilityHint(for: title))
    }

    private func accessibilityHint(for title: String) -> String {
        switch title {
        case "填入首页重新查询":
            return "将这条历史记录的出生日期和时辰填入首页，不会自动查询。"
        case "收藏记录", "取消收藏":
            return "切换这条历史记录的本机收藏状态。"
        default:
            return "切换这条历史记录的本机置顶状态。"
        }
    }
}
