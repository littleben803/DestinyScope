//
//  KnowledgeTagFlowView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct KnowledgeTagFlowView: View {
    let tags: [String]
    var limit: Int?

    private var displayedTags: [String] {
        guard let limit else {
            return tags
        }
        return Array(tags.prefix(limit))
    }

    private let columns = [
        GridItem(.adaptive(minimum: 72), spacing: AppTheme.Spacing.sm, alignment: .leading)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: AppTheme.Spacing.sm) {
            ForEach(displayedTags, id: \.self) { tag in
                Text(tag)
                    .font(AppTheme.Typography.caption.weight(.medium))
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(AppTheme.Colors.secondaryBackground.opacity(0.55))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(AppTheme.Colors.divider.opacity(0.45), lineWidth: 1)
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
