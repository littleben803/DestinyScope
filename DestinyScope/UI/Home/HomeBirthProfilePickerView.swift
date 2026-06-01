//
//  HomeBirthProfilePickerView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct HomeBirthProfilePickerView: View {
    let profiles: [SavedBirthProfile]
    let onSelect: (SavedBirthProfile) -> Void
    let onSaveCurrent: () -> Void

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                HStack(alignment: .firstTextBaseline) {
                    AppSectionHeader(title: "常用资料")

                    Spacer()

                    Text("本机保存")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.darkGold)
                }

                Text("资料仅保存在本机，不会上传或同步。选择后只会填入首页输入，不会自动查询。")
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                if profiles.isEmpty {
                    Text("暂无常用出生资料。你可以先保存当前输入，方便之后快速填写。")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppTheme.Spacing.sm) {
                            ForEach(profiles) { profile in
                                Button {
                                    onSelect(profile)
                                } label: {
                                    profileChip(profile)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("选择常用资料 \(profile.displayName)")
                                .accessibilityHint("将出生日期和时辰填入首页输入，不会自动查询。")
                            }
                        }
                        .padding(.vertical, AppTheme.Spacing.xs)
                    }
                }

                Button(action: onSaveCurrent) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("保存当前出生资料")
                    }
                    .font(AppTheme.Typography.body.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.cinnabar)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.md)
                    .background(AppTheme.Colors.secondaryBackground.opacity(0.45))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("保存当前出生资料")
                .accessibilityHint("输入本地显示名后，将当前出生日期和时辰保存到本机。")
            }
        }
    }

    private func profileChip(_ profile: SavedBirthProfile) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(profile.displayName)
                .font(AppTheme.Typography.body.weight(.semibold))
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineLimit(2)

            Text(profile.birthSummaryText)
                .font(AppTheme.Typography.footnote)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .frame(width: 168, alignment: .leading)
        .background(AppTheme.Colors.paper)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous)
                .stroke(AppTheme.Colors.divider.opacity(0.55), lineWidth: 1)
        )
    }
}
