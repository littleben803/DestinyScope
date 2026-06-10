//
//  AnimatedTitlePage.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/10.
//

import SwiftUI

struct AnimatedTitlePageContext {
    let largeTitleOpacity: Double
    let updateScrollOffset: (CGFloat) -> Void
}

struct AnimatedTitlePage<Content: View>: View {
    private enum TitleMode {
        case large
        case inline
    }

    private let title: String
    private let content: (AnimatedTitlePageContext) -> Content

    private let inlineTitleShowOffset: CGFloat
    private let largeTitleRestoreOffset: CGFloat
    private let inlineTitleHeight: CGFloat
    private let inlineTitleTopMargin: CGFloat
    private let titleFadeAnimation: Animation

    @State private var titleMode: TitleMode = .large

    init(
        title: String,
        inlineTitleShowOffset: CGFloat = 72,
        largeTitleRestoreOffset: CGFloat = 4,
        inlineTitleHeight: CGFloat = 32,
        inlineTitleTopMargin: CGFloat = 6,
        titleFadeAnimation: Animation = .easeInOut(duration: 0.12),
        @ViewBuilder content: @escaping (AnimatedTitlePageContext) -> Content
    ) {
        self.title = title
        self.inlineTitleShowOffset = inlineTitleShowOffset
        self.largeTitleRestoreOffset = largeTitleRestoreOffset
        self.inlineTitleHeight = inlineTitleHeight
        self.inlineTitleTopMargin = inlineTitleTopMargin
        self.titleFadeAnimation = titleFadeAnimation
        self.content = content
    }

    var body: some View {
        content(context)
            .navigationTitle("")
            .toolbar(.hidden, for: .navigationBar)
            .overlay(alignment: .top) {
                GeometryReader { proxy in
                    AnimatedInlineTitle(
                        title: title,
                        opacity: inlineTitleOpacity,
                        height: inlineTitleHeight
                    )
                    .frame(width: proxy.size.width)
                    .padding(.top, inlineTitleTopMargin)
                }
                .animation(titleFadeAnimation, value: titleMode)
                .allowsHitTesting(false)
            }
    }

    private var context: AnimatedTitlePageContext {
        AnimatedTitlePageContext(
            largeTitleOpacity: largeTitleOpacity,
            updateScrollOffset: updateTitleMode
        )
    }

    private var largeTitleOpacity: Double {
        titleMode == .large ? 1 : 0
    }

    private var inlineTitleOpacity: Double {
        titleMode == .inline ? 1 : 0
    }

    private func updateTitleMode(for offset: CGFloat) {
        let nextMode: TitleMode

        if offset <= largeTitleRestoreOffset {
            nextMode = .large
        } else if offset >= inlineTitleShowOffset {
            nextMode = .inline
        } else {
            return
        }

        guard nextMode != titleMode else {
            return
        }

        withAnimation(titleFadeAnimation) {
            titleMode = nextMode
        }
    }
}

struct AnimatedTitleHeader: View {
    let title: String
    let subtitle: String?
    let titleOpacity: Double

    init(title: String, subtitle: String? = nil, titleOpacity: Double) {
        self.title = title
        self.subtitle = subtitle
        self.titleOpacity = titleOpacity
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text(title)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
                .opacity(titleOpacity)
                .accessibilityHidden(titleOpacity < 0.01)

            if let subtitle {
                Text(subtitle)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.darkGold)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension View {
    func animatedTitleScrollTracking(_ context: AnimatedTitlePageContext) -> some View {
        onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentOffset.y + geometry.contentInsets.top
        } action: { _, newOffset in
            context.updateScrollOffset(max(0, newOffset))
        }
    }
}

private struct AnimatedInlineTitle: View {
    let title: String
    let opacity: Double
    let height: CGFloat

    var body: some View {
        Text(title)
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(AppTheme.Colors.primaryText)
            .lineLimit(1)
            .minimumScaleFactor(0.82)
            .frame(maxWidth: .infinity)
            .frame(height: height, alignment: .center)
            .opacity(opacity)
            .accessibilityHidden(opacity < 0.01)
    }
}
