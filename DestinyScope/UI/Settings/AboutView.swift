//
//  AboutView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    AppCard {
                        Text(localizationStore.string(.appName))
                            .font(AppTheme.Typography.pageTitle)
                            .foregroundColor(AppTheme.Colors.primaryText)

                        Text(localizationStore.string(.aboutTagline))
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)

                        Text(localizationStore.string(.aboutBody))
                            .font(AppTheme.Typography.secondary)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    AppCard {
                        AppSectionHeader(title: localizationStore.string(.aboutCapabilitiesTitle))

                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            bullet(localizationStore.string(.aboutCapabilityBirth))
                            bullet(localizationStore.string(.aboutCapabilityOffline))
                            bullet(localizationStore.string(.aboutCapabilityHistory))
                            bullet(localizationStore.string(.aboutCapabilityLocalModel))
                        }
                    }

                    AppCard {
                        AppSectionHeader(title: localizationStore.string(.aboutBoundaryTitle))

                        Text(localizationStore.string(.aboutBoundaryBody))
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    SettingsSectionCard(title: localizationStore.string(.aboutHelpTitle)) {
                        legalLink(
                            title: localizationStore.string(.settingsOnboardingTitle),
                            subtitle: localizationStore.string(.settingsOnboardingSubtitle),
                            systemImage: "book.closed",
                            accessibilityHint: localizationStore.string(.settingsOnboardingAccessibilityHint)
                        ) {
                            OnboardingView(isReviewMode: true)
                        }
                    }

                    SettingsSectionCard(title: localizationStore.string(.aboutLegalPrivacyTitle)) {
                        legalLink(
                            title: localizationStore.string(.settingsPrivacyPolicyTitle),
                            subtitle: localizationStore.string(.aboutPrivacySubtitle),
                            systemImage: "lock.shield",
                            accessibilityHint: localizationStore.string(.settingsPrivacyPolicyAccessibilityHint)
                        ) {
                            PrivacyPolicyView()
                        }

                        Divider()
                            .background(AppTheme.Colors.divider)

                        legalLink(
                            title: localizationStore.string(.settingsDisclaimerTitle),
                            subtitle: localizationStore.string(.aboutDisclaimerSubtitle),
                            systemImage: "exclamationmark.triangle",
                            accessibilityHint: localizationStore.string(.settingsDisclaimerAccessibilityHint)
                        ) {
                            DisclaimerView()
                        }

                        Divider()
                            .background(AppTheme.Colors.divider)

                        legalLink(
                            title: localizationStore.string(.settingsOpenSourceTitle),
                            subtitle: localizationStore.string(.aboutOpenSourceSubtitle),
                            systemImage: "doc.text",
                            accessibilityHint: localizationStore.string(.settingsOpenSourceAccessibilityHint)
                        ) {
                            OpenSourceLicensesView()
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(localizationStore.string(.aboutNavigationTitle))
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Text("•")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.darkGold)

            Text(text)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func legalLink<Destination: View>(
        title: String,
        subtitle: String,
        systemImage: String,
        accessibilityHint: String,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink {
            destination()
        } label: {
            HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                Image(systemName: systemImage)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .frame(width: 22)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(title)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(subtitle)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityHint(accessibilityHint)
    }
}
