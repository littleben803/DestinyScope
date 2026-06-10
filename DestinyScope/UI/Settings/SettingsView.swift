//
//  SettingsView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        let pageTitle = localizationStore.string(.settingsNavigationTitle)

        AnimatedTitlePage(title: pageTitle) { titleContext in
            AppBackground {
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.md) {
                        AnimatedTitleHeader(title: pageTitle, titleOpacity: titleContext.largeTitleOpacity)

                        SettingsSectionCard(
                            title: localizationStore.string(.settingsApplicationSectionTitle),
                            subtitle: localizationStore.string(.settingsApplicationSectionSubtitle)
                        ) {
                            settingsLink(
                                title: localizationStore.string(.settingsAboutTitle),
                                subtitle: localizationStore.string(.settingsAboutSubtitle),
                                systemImage: "info.circle",
                                accessibilityHint: localizationStore.string(.settingsAboutAccessibilityHint)
                            ) {
                                AboutView()
                            }

                            Divider()
                                .background(AppTheme.Colors.divider)

                            settingsLink(
                                title: localizationStore.string(.settingsOnboardingTitle),
                                subtitle: localizationStore.string(.settingsOnboardingSubtitle),
                                systemImage: "book.closed",
                                accessibilityHint: localizationStore.string(.settingsOnboardingAccessibilityHint)
                            ) {
                                OnboardingView(isReviewMode: true)
                            }

                            Divider()
                                .background(AppTheme.Colors.divider)

                            settingsLink(
                                title: localizationStore.string(.settingsLanguageTitle),
                                subtitle: languageSubtitle,
                                systemImage: "globe",
                                accessibilityHint: localizationStore.string(.settingsLanguageAccessibilityHint)
                            ) {
                                LanguageSettingsView()
                            }
                        }

                        SettingsSectionCard(
                            title: localizationStore.string(.settingsPrivacySectionTitle),
                            subtitle: localizationStore.string(.settingsPrivacySectionSubtitle)
                        ) {
                            settingsLink(
                                title: localizationStore.string(.settingsPrivacyPolicyTitle),
                                subtitle: localizationStore.string(.settingsPrivacyPolicySubtitle),
                                systemImage: "lock.shield",
                                accessibilityHint: localizationStore.string(.settingsPrivacyPolicyAccessibilityHint)
                            ) {
                                PrivacyPolicyView()
                            }

                            Divider()
                                .background(AppTheme.Colors.divider)

                            settingsLink(
                                title: localizationStore.string(.settingsDisclaimerTitle),
                                subtitle: localizationStore.string(.settingsDisclaimerSubtitle),
                                systemImage: "exclamationmark.triangle",
                                accessibilityHint: localizationStore.string(.settingsDisclaimerAccessibilityHint)
                            ) {
                                DisclaimerView()
                            }

                            Divider()
                                .background(AppTheme.Colors.divider)

                            settingsLink(
                                title: localizationStore.string(.settingsOpenSourceTitle),
                                subtitle: localizationStore.string(.settingsOpenSourceSubtitle),
                                systemImage: "doc.text",
                                accessibilityHint: localizationStore.string(.settingsOpenSourceAccessibilityHint)
                            ) {
                                OpenSourceLicensesView()
                            }
                        }

                        SettingsSectionCard(
                            title: localizationStore.string(.settingsLocalDataSectionTitle),
                            subtitle: localizationStore.string(.settingsLocalDataSectionSubtitle)
                        ) {
                            settingsLink(
                                title: localizationStore.string(.settingsLocalDataManagementTitle),
                                subtitle: localizationStore.string(.settingsLocalDataManagementSubtitle),
                                systemImage: "folder",
                                accessibilityHint: localizationStore.string(.settingsLocalDataManagementAccessibilityHint)
                            ) {
                                LocalDataManagementView()
                            }
                        }
                    }
                    .padding(AppTheme.Spacing.lg)
                }
                .animatedTitleScrollTracking(titleContext)
            }
        }
    }

    private func settingsLink<Destination: View>(
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
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .frame(width: 24)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text(title)
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(subtitle)
                        .font(AppTheme.Typography.secondary)
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

    private var languageSubtitle: String {
        let languageName = localizationStore.string(localizationStore.currentLanguage.displayNameID)

        switch localizationStore.languagePreference {
        case .system:
            return localizationStore.string(
                .settingsLanguageCurrentSystem,
                replacements: ["language": languageName]
            )
        case .simplifiedChinese, .traditionalChinese, .english:
            return localizationStore.string(
                .settingsLanguageCurrentManual,
                replacements: ["language": languageName]
            )
        }
    }
}
