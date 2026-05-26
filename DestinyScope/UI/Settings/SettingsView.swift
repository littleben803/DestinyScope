//
//  SettingsView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        AppBackground {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    NavigationLink {
                        AboutView()
                    } label: {
                        AppCard {
                            HStack {
                                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                    Text("关于 DestinyScope")
                                        .font(AppTheme.Typography.sectionTitle)
                                        .foregroundColor(AppTheme.Colors.primaryText)

                                    Text("本地传统命理数据与隐私说明")
                                        .font(AppTheme.Typography.secondary)
                                        .foregroundColor(AppTheme.Colors.secondaryText)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.Colors.secondaryText)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("关于")
    }
}
