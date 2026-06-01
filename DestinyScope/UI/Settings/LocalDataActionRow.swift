//
//  LocalDataActionRow.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct LocalDataActionRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let isDestructive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                Image(systemName: systemImage)
                    .font(.title3)
                    .foregroundColor(isDestructive ? AppTheme.Colors.cinnabar : AppTheme.Colors.darkGold)
                    .frame(width: 28)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(title)
                        .font(AppTheme.Typography.body.weight(.semibold))
                        .foregroundColor(isDestructive ? AppTheme.Colors.cinnabar : AppTheme.Colors.primaryText)

                    Text(subtitle)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint(subtitle)
    }
}
