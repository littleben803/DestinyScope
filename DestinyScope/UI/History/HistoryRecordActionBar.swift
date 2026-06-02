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

    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string("history.actions.title"))

            Text(localizationStore.string("history.actions.notice"))
                .font(AppTheme.Typography.footnote)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: AppTheme.Spacing.sm) {
                actionButton(
                    title: isFavorite
                        ? localizationStore.string("history.actions.unfavorite")
                        : localizationStore.string("history.actions.favorite"),
                    systemImageName: isFavorite ? "star.slash" : "star",
                    accessibilityHint: localizationStore.string("history.actions.favorite.accessibilityHint"),
                    action: onToggleFavorite
                )

                actionButton(
                    title: isPinned
                        ? localizationStore.string("history.actions.unpin")
                        : localizationStore.string("history.actions.pin"),
                    systemImageName: isPinned ? "pin.slash" : "pin",
                    accessibilityHint: localizationStore.string("history.actions.pin.accessibilityHint"),
                    action: onTogglePinned
                )

                actionButton(
                    title: localizationStore.string("history.actions.reuse"),
                    systemImageName: "arrowshape.turn.up.left",
                    accessibilityHint: localizationStore.string("history.actions.reuse.accessibilityHint"),
                    action: onReuseInput
                )
            }
        }
    }

    private func actionButton(
        title: String,
        systemImageName: String,
        accessibilityHint: String,
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
        .accessibilityHint(accessibilityHint)
    }
}
