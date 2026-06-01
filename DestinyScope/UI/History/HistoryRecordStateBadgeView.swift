//
//  HistoryRecordStateBadgeView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct HistoryRecordStateBadgeView: View {
    let title: String
    let systemImageName: String

    var body: some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            Image(systemName: systemImageName)
            Text(title)
        }
        .font(AppTheme.Typography.caption.weight(.semibold))
        .foregroundColor(AppTheme.Colors.darkGold)
        .padding(.horizontal, AppTheme.Spacing.sm)
        .padding(.vertical, AppTheme.Spacing.xs)
        .background(AppTheme.Colors.secondaryBackground.opacity(0.55))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(AppTheme.Colors.divider.opacity(0.45), lineWidth: 1)
        )
    }
}
