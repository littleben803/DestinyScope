//
//  OnboardingPage.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct OnboardingPage: Identifiable, Equatable {
    let id: Int
    let systemImageName: String
    let titleID: L10nID
    let bodyID: L10nID
}

extension OnboardingPage {
    static let v1_6Pages: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            systemImageName: "sparkles",
            titleID: "onboarding.page.0.title",
            bodyID: "onboarding.page.0.body"
        ),
        OnboardingPage(
            id: 1,
            systemImageName: "lock.shield",
            titleID: "onboarding.page.1.title",
            bodyID: "onboarding.page.1.body"
        ),
        OnboardingPage(
            id: 2,
            systemImageName: "leaf",
            titleID: "onboarding.page.2.title",
            bodyID: "onboarding.page.2.body"
        ),
        OnboardingPage(
            id: 3,
            systemImageName: "book.closed",
            titleID: "onboarding.page.3.title",
            bodyID: "onboarding.page.3.body"
        )
    ]
}
