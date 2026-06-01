//
//  OnboardingStateStore.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct OnboardingStateStore {
    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var hasCompletedOnboarding: Bool {
        userDefaults.bool(forKey: Keys.hasCompletedOnboarding)
    }

    func markCompleted() {
        userDefaults.set(true, forKey: Keys.hasCompletedOnboarding)
    }

    func reset() {
        userDefaults.set(false, forKey: Keys.hasCompletedOnboarding)
    }
}

