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

    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.xs) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                Text(isFavorite
                     ? localizationStore.string("knowledge.favorite.selected")
                     : localizationStore.string("knowledge.favorite.add"))
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
        .accessibilityLabel(
            isFavorite
                ? localizationStore.string("knowledge.favorite.remove.accessibilityLabel")
                : localizationStore.string("knowledge.favorite.add.accessibilityLabel")
        )
        .accessibilityHint(
            isFavorite
                ? localizationStore.string("knowledge.favorite.remove.accessibilityHint")
                : localizationStore.string("knowledge.favorite.add.accessibilityHint")
        )
    }
}
