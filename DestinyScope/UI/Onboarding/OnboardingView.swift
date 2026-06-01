//
//  OnboardingView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct OnboardingView: View {
    let isReviewMode: Bool
    let onFinish: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var selectedPage = 0

    private let pages = OnboardingPage.v1_6Pages

    init(isReviewMode: Bool = false, onFinish: (() -> Void)? = nil) {
        self.isReviewMode = isReviewMode
        self.onFinish = onFinish
    }

    var body: some View {
        AppBackground {
            VStack(spacing: AppTheme.Spacing.lg) {
                header

                TabView(selection: $selectedPage) {
                    ForEach(pages.indices, id: \.self) { index in
                        ScrollView {
                            OnboardingPageCard(page: pages[index])
                                .padding(.horizontal, AppTheme.Spacing.lg)
                                .padding(.top, AppTheme.Spacing.md)
                                .padding(.bottom, AppTheme.Spacing.xl)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))

                controls
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.bottom, AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("使用说明")
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled(!isReviewMode)
    }

    private var header: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Text("使用说明")
                .font(AppTheme.Typography.pageTitle)
                .foregroundColor(AppTheme.Colors.primaryText)

            Text("了解本地计算、隐私和结果边界")
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.xl)
    }

    private var controls: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Button {
                if isLastPage {
                    finish()
                } else {
                    withAnimation {
                        selectedPage += 1
                    }
                }
            } label: {
                Text(isLastPage ? finishTitle : "下一步")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.md)
                    .background(AppTheme.Colors.cinnabar)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.button, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isLastPage ? finishTitle : "下一步")
            .accessibilityHint(isLastPage ? finishHint : "查看下一页使用说明。")

            if selectedPage > 0 {
                Button {
                    withAnimation {
                        selectedPage -= 1
                    }
                } label: {
                    Text("上一步")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.cinnabar)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.sm)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("上一步")
                .accessibilityHint("返回上一页使用说明。")
            }
        }
    }

    private var isLastPage: Bool {
        selectedPage == pages.count - 1
    }

    private var finishTitle: String {
        isReviewMode ? "完成" : "开始使用"
    }

    private var finishHint: String {
        isReviewMode ? "关闭使用说明。" : "完成使用说明并进入应用。"
    }

    private func finish() {
        if let onFinish {
            onFinish()
        } else {
            dismiss()
        }
    }
}

#Preview {
    OnboardingView(isReviewMode: true)
}
