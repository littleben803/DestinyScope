//
//  KnowledgeFavoriteButton.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct KnowledgeFavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.xs) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                Text(isFavorite ? "已收藏" : "收藏")
            }
            .font(AppTheme.Typography.footnote.weight(.semibold))
            .foregroundColor(isFavorite ? AppTheme.Colors.paper : AppTheme.Colors.cinnabar)
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(isFavorite ? AppTheme.Colors.cinnabar : AppTheme.Colors.secondaryBackground.opacity(0.45))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(AppTheme.Colors.cinnabar.opacity(0.65), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isFavorite ? "取消收藏文章" : "收藏文章")
        .accessibilityHint(isFavorite ? "从本机收藏中移除这篇知识文章。" : "将这篇知识文章加入本机收藏。")
    }
}
