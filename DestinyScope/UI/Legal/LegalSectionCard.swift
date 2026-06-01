//
//  LegalSectionCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct LegalSectionCard: View {
    let title: String
    let bodyText: String

    var body: some View {
        AppCard {
            AppSectionHeader(title: title)

            Text(bodyText)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
