//
//  InsightTagsView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct InsightTagsView: View {
    let tags: [String]

    private let columns = [
        GridItem(.adaptive(minimum: 88), spacing: AppTheme.Spacing.sm)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: AppTheme.Spacing.sm) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.cinnabar)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.Colors.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous)
                            .stroke(AppTheme.Colors.divider.opacity(0.6), lineWidth: 1)
                    )
            }
        }
    }
}
