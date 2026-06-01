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

    @State private var hasCopied = false

    private let builder = ResultShareTextBuilder()
    private let clipboardWriter = ClipboardWriter()

    private var shareText: String {
        builder.build(result: result, interpretation: interpretation, insight: insight)
    }

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                AppSectionHeader(title: "复制与分享")

                Text("复制一段不含完整出生信息的结果摘要，方便自己保存或分享。分享给其他 App 是你的主动操作，DestinyScope 不会自动上传分享内容。")
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
                            Text("复制摘要")
                        }
                        .font(AppTheme.Typography.body.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(AppTheme.Colors.cinnabar)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.button, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("复制结果摘要")
                    .accessibilityHint("将不含完整出生信息的结果摘要复制到剪贴板。")

                    ShareLink(item: shareText) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("分享摘要")
                        }
                        .font(AppTheme.Typography.body.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.cinnabar)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(AppTheme.Colors.secondaryBackground.opacity(0.45))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.button, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("分享结果摘要")
                    .accessibilityHint("打开系统分享面板，分享不含完整出生信息的纯文本摘要。")
                }

                if hasCopied {
                    Text("已复制到剪贴板。")
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.darkGold)
                        .transition(.opacity)
                }

                Text("默认摘要不包含完整出生日期、农历生日、具体出生时辰、历史记录或本地模型润色结果。")
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
