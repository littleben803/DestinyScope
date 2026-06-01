//
//  LegalInfoRow.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct LegalInfoRow: View {
    let title: String
    let value: String
    var allowsSelection = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(title)
                .font(AppTheme.Typography.footnote.weight(.semibold))
                .foregroundColor(AppTheme.Colors.secondaryText)

            Text(value)
                .modifier(SelectableLegalTextModifier(allowsSelection: allowsSelection))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct SelectableLegalTextModifier: ViewModifier {
    let allowsSelection: Bool

    func body(content: Content) -> some View {
        Group {
            if allowsSelection {
                content
                    .textSelection(.enabled)
            } else {
                content
            }
        }
        .font(AppTheme.Typography.body)
        .foregroundColor(AppTheme.Colors.primaryText)
        .lineSpacing(4)
        .fixedSize(horizontal: false, vertical: true)
    }
}
