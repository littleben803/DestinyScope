//
//  LegalSummaryCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct LegalSummaryCard: View {
    let title: String
    let bodyText: String
    let highlights: [String]

    var body: some View {
        AppCard {
            Text(title)
                .font(AppTheme.Typography.pageTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Text(bodyText)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            if !highlights.isEmpty {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    ForEach(highlights, id: \.self) { highlight in
                        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                            Text("•")
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.darkGold)

                            Text(highlight)
                                .font(AppTheme.Typography.secondary)
                                .foregroundColor(AppTheme.Colors.primaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }
}
