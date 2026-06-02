//
//  ResultTextShareCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct ResultTextShareCard: View {
    let result: LifeWeightResult
    let interpretation: FortuneInterpretation
    let insight: LifeWeightInsight

    @EnvironmentObject private var localizationStore: LocalizationStore

    @State private var hasCopied = false

    private let builder = ResultShareTextBuilder()
    private let clipboardWriter = ClipboardWriter()

    private var shareText: String {
        builder.build(
            result: result,
            interpretation: interpretation,
            insight: insight,
            localizationStore: localizationStore
        )
    }

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                AppSectionHeader(title: localizationStore.string("result.share.title"))

                Text(localizationStore.string("result.share.description"))
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(spacing: AppTheme.Spacing.sm) {
                    Button {
                        clipboardWriter.copy(shareText)
                        hasCopied = true
                    } label: {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text(localizationStore.string("result.share.copy"))
                        }
                        .font(AppTheme.Typography.body.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(AppTheme.Colors.cinnabar)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.button, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(localizationStore.string("result.share.copy.accessibilityLabel"))
                    .accessibilityHint(localizationStore.string("result.share.copy.accessibilityHint"))

                    ShareLink(item: shareText) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text(localizationStore.string("result.share.share"))
                        }
                        .font(AppTheme.Typography.body.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.cinnabar)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(AppTheme.Colors.secondaryBackground.opacity(0.45))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.button, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(localizationStore.string("result.share.share.accessibilityLabel"))
                    .accessibilityHint(localizationStore.string("result.share.share.accessibilityHint"))
                }

                if hasCopied {
                    Text(localizationStore.string("result.share.copied"))
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.darkGold)
                        .transition(.opacity)
                }

                Text(localizationStore.string("result.share.privacyNotice"))
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
