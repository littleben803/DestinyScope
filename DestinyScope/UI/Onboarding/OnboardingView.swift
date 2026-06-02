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
    @EnvironmentObject private var localizationStore: LocalizationStore
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
        .navigationTitle(localizationStore.string(.onboardingNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled(!isReviewMode)
    }

    private var header: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Text(localizationStore.string(.onboardingHeaderTitle))
                .font(AppTheme.Typography.pageTitle)
                .foregroundColor(AppTheme.Colors.primaryText)

            Text(localizationStore.string(.onboardingHeaderSubtitle))
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
                Text(isLastPage ? finishTitle : localizationStore.string(.onboardingNext))
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.md)
                    .background(AppTheme.Colors.cinnabar)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.button, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isLastPage ? finishTitle : localizationStore.string(.onboardingNext))
            .accessibilityHint(isLastPage ? finishHint : localizationStore.string(.onboardingNextHint))

            if selectedPage > 0 {
                Button {
                    withAnimation {
                        selectedPage -= 1
                    }
                } label: {
                    Text(localizationStore.string(.onboardingPrevious))
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.cinnabar)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.sm)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(localizationStore.string(.onboardingPrevious))
                .accessibilityHint(localizationStore.string(.onboardingPreviousHint))
            }
        }
    }

    private var isLastPage: Bool {
        selectedPage == pages.count - 1
    }

    private var finishTitle: String {
        isReviewMode
            ? localizationStore.string(.onboardingDone)
            : localizationStore.string(.onboardingStart)
    }

    private var finishHint: String {
        isReviewMode
            ? localizationStore.string(.onboardingDoneHint)
            : localizationStore.string(.onboardingStartHint)
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
        .environmentObject(LocalizationStore())
}
