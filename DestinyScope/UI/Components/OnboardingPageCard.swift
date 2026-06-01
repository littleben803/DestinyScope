//
//  OnboardingPageCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct OnboardingPageCard: View {
    let page: OnboardingPage

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                Image(systemName: page.systemImageName)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .accessibilityHidden(true)

                Text(page.title)
                    .font(AppTheme.Typography.pageTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Text(page.body)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(page.title)。\(page.body)")
    }
}

