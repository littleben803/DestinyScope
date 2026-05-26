//
//  AppSectionHeader.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct AppSectionHeader: View {
    let title: String

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Rectangle()
                .fill(AppTheme.Colors.darkGold)
                .frame(width: 4, height: 18)
                .clipShape(RoundedRectangle(cornerRadius: 2, style: .continuous))

            Text(title)
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
