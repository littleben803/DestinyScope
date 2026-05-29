//
//  LocalModelExperimentSettingsView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import SwiftUI

struct LocalModelExperimentSettingsView: View {
    @StateObject private var settings = LocalModelExperimentSettings()

    private let config = LocalModelExperimentConfig.current

    private var availability: LocalModelExperimentAvailability {
        LocalModelExperimentAvailability.current(settings: settings)
    }

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    AppSectionHeader(title: config.featureName)

                    AppCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            Text(config.descriptionText)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)

                            Text(config.safetyNoticeText)
                                .font(AppTheme.Typography.secondary)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                        }
                    }

                    AppCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            statusRow
                            deviceTierSection

                            Text("说明")
                                .font(AppTheme.Typography.sectionTitle)
                                .foregroundColor(AppTheme.Colors.primaryText)

                            bullet("使用设备端本地模型对已有模板文本做表达润色。")
                            bullet("不生成新的命理结论。")
                            bullet("不替代称骨计算和模板规则。")
                            bullet("不上传出生信息、命理结果、模型输入输出或历史记录。")
                            bullet("可能较慢、耗电或失败。")
                            bullet("失败会回退本地模板文本。")
                            bullet("当前仅用于 Debug/TestFlight 内测。")
                        }
                    }

                    if !availability.isBuildAvailable || !availability.isDeviceAllowed {
                        unavailableCard
                    } else if !settings.hasAcceptedExperimentNotice {
                        consentCard
                    } else {
                        toggleCard
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(config.featureName)
        .onAppear(perform: enforceAvailability)
    }

    private var statusRow: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("当前状态")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)

            Text(statusText)
                .font(AppTheme.Typography.body)
                .foregroundColor(statusColor)
        }
    }

    private var statusText: String {
        if !availability.isAvailable, let reason = availability.reason {
            return "不可用：\(reason)"
        }
        return settings.isExperimentEnabled ? "已开启" : "已关闭"
    }

    private var statusColor: Color {
        if !availability.isAvailable {
            return AppTheme.Colors.secondaryText
        }
        return settings.isExperimentEnabled ? AppTheme.Colors.darkGold : AppTheme.Colors.secondaryText
    }

    private var deviceTierSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("设备分级")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)

            infoRow(title: "设备标识", value: availability.deviceIdentifier)
            infoRow(title: "当前分级", value: availability.deviceTier.displayName)
            infoRow(title: "分级说明", value: availability.deviceTier.description)
            infoRow(
                title: "是否允许实验",
                value: availability.isDeviceAllowed ? "允许" : "不允许"
            )
            infoRow(
                title: "推荐超时",
                value: availability.timeoutSeconds.map { "\(Int($0)) 秒" } ?? "不启用"
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
                Text("不可用")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text(availability.reason ?? "当前构建不开放本地模型润色实验。")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
        }
    }

    private var consentCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("开启前确认")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text("我理解这是实验功能，结果仅供娱乐、自我探索和传统文化学习参考。")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)

                AppPrimaryButton(title: "我理解这是实验功能") {
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
                    Text("启用本地模型润色实验")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
                .tint(AppTheme.Colors.cinnabar)
                .disabled(!availability.isAvailable)

                AppPrimaryButton(title: "重置实验确认") {
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
