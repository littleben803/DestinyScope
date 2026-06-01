//
//  SavedBirthProfileRowView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct SavedBirthProfileRowView: View {
    let profile: SavedBirthProfile

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text(profile.displayName)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("出生：\(profile.birthSummaryText)")
                    Text("更新：\(profile.updatedAtText)")
                }
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(profile.displayName)，出生 \(profile.birthSummaryText)，更新 \(profile.updatedAtText)")
    }
}
