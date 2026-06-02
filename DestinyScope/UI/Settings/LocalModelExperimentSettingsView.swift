//
//  LocalModelExperimentSettingsView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import SwiftUI

struct LocalModelExperimentSettingsView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    @StateObject private var settings = LocalModelExperimentSettings()

    private var availability: LocalModelExperimentAvailability {
        LocalModelExperimentAvailability.current(settings: settings)
    }

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    AppSectionHeader(title: localizationStore.string("localModel.experiment.title"))

                    AppCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            Text(localizationStore.string("localModel.experiment.description"))
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)

                            Text(localizationStore.string("localModel.experiment.safetyNotice"))
                                .font(AppTheme.Typography.secondary)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                        }
                    }

                    AppCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            statusRow
                            deviceTierSection

                            Text(localizationStore.string("localModel.experiment.notesTitle"))
                                .font(AppTheme.Typography.sectionTitle)
                                .foregroundColor(AppTheme.Colors.primaryText)

                            bullet(localizationStore.string("localModel.experiment.note.0"))
                            bullet(localizationStore.string("localModel.experiment.note.1"))
                            bullet(localizationStore.string("localModel.experiment.note.2"))
                            bullet(localizationStore.string("localModel.experiment.note.3"))
                            bullet(localizationStore.string("localModel.experiment.note.4"))
                            bullet(localizationStore.string("localModel.experiment.note.5"))
                            bullet(localizationStore.string("localModel.experiment.note.6"))
                        }
                    }

                    if !availability.isBuildAvailable || !availability.isDeviceAllowed {
                        unavailableCard
                    } else if !settings.hasAcceptedExperimentNotice {
                        consentCard
                    } else if !availability.isModelFileUsable {
                        unavailableCard
                    } else {
                        toggleCard
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(localizationStore.string("localModel.experiment.title"))
        .onAppear(perform: enforceAvailability)
    }

    private var statusRow: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(localizationStore.string("localModel.experiment.currentStatus"))
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)

            Text(statusText)
                .font(AppTheme.Typography.body)
                .foregroundColor(statusColor)
        }
    }

    private var statusText: String {
        if !availability.isAvailable, let reason = availability.reason {
            return localizationStore.string("localModel.experiment.unavailableWithReason", replacements: ["reason": reason])
        }
        return settings.isExperimentEnabled
            ? localizationStore.string("localModel.experiment.enabled")
            : localizationStore.string("localModel.experiment.disabled")
    }

    private var statusColor: Color {
        if !availability.isAvailable {
            return AppTheme.Colors.secondaryText
        }
        return settings.isExperimentEnabled ? AppTheme.Colors.darkGold : AppTheme.Colors.secondaryText
    }

    private var deviceTierSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(localizationStore.string("localModel.experiment.deviceTier"))
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)

            infoRow(title: localizationStore.string("localModel.experiment.deviceIdentifier"), value: availability.deviceIdentifier)
            infoRow(title: localizationStore.string("localModel.experiment.currentTier"), value: availability.deviceTier.displayName)
            infoRow(title: localizationStore.string("localModel.experiment.tierDescription"), value: availability.deviceTier.description)
            infoRow(
                title: localizationStore.string("localModel.experiment.isAllowed"),
                value: availability.isDeviceAllowed
                    ? localizationStore.string("common.allowed")
                    : localizationStore.string("common.notAllowed")
            )
            infoRow(
                title: localizationStore.string("localModel.experiment.recommendedTimeout"),
                value: availability.timeoutSeconds.map {
                    localizationStore.string("common.duration.seconds.integer", replacements: ["seconds": "\(Int($0))"])
                } ?? localizationStore.string("common.notEnabled")
            )

            Text(availability.deviceTier.userFacingNotice)
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)

            if availability.isAvailable, let reason = availability.reason {
                Text(reason)
                    .font(AppTheme.Typography.secondary)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
        }
    }

    private var unavailableCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text(localizationStore.string("localModel.experiment.unavailable"))
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text(availability.reason ?? localizationStore.string("localModel.experiment.buildUnavailable"))
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
        }
    }

    private var consentCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text(localizationStore.string("localModel.experiment.consentTitle"))
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text(localizationStore.string("localModel.experiment.consentBody"))
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)

                AppPrimaryButton(title: localizationStore.string("localModel.experiment.acceptConsent")) {
                    settings.acceptNotice()
                }
            }
        }
    }

    private var toggleCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Toggle(isOn: Binding(
                    get: { settings.isExperimentEnabled },
                    set: { isOn in
                        if isOn {
                            guard availability.isAvailable else {
                                settings.disableExperiment()
                                return
                            }
                            settings.enableExperiment()
                        } else {
                            settings.disableExperiment()
                        }
                    }
                )) {
                    Text(localizationStore.string("localModel.experiment.toggleTitle"))
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
                .tint(AppTheme.Colors.cinnabar)
                .disabled(!availability.isAvailable)

                AppPrimaryButton(title: localizationStore.string("localModel.experiment.resetConsent")) {
                    settings.reset()
                }
            }
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Text(title)
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .frame(width: 88, alignment: .leading)

            Text(value)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
        }
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Text("•")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.darkGold)

            Text(text)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
        }
    }

    private func enforceAvailability() {
        if settings.isExperimentEnabled && !availability.isAvailable {
            settings.disableExperiment()
        }
    }
}
