//
//  OnboardingPageCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct OnboardingPageCard: View {
    let page: OnboardingPage

    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                Image(systemName: page.systemImageName)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .accessibilityHidden(true)

                Text(titleText)
                    .font(AppTheme.Typography.pageTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Text(bodyText)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(titleText). \(bodyText)")
    }

    private var titleText: String {
        localizationStore.string(page.titleID)
    }

    private var bodyText: String {
        localizationStore.string(page.bodyID)
    }
}
