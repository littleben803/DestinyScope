//
//  LocalModelExperimentSettings.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import Combine
import Foundation

final class LocalModelExperimentSettings: ObservableObject {
    private enum Keys {
        static let isExperimentEnabled = "localModelExperiment.isExperimentEnabled"
        static let hasAcceptedExperimentNotice = "localModelExperiment.hasAcceptedExperimentNotice"
    }

    @Published private(set) var isExperimentEnabled: Bool
    @Published private(set) var hasAcceptedExperimentNotice: Bool

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        isExperimentEnabled = userDefaults.bool(forKey: Keys.isExperimentEnabled)
        hasAcceptedExperimentNotice = userDefaults.bool(forKey: Keys.hasAcceptedExperimentNotice)

        if !hasAcceptedExperimentNotice && isExperimentEnabled {
            isExperimentEnabled = false
            userDefaults.set(false, forKey: Keys.isExperimentEnabled)
        }
    }

    func acceptNotice() {
        hasAcceptedExperimentNotice = true
        userDefaults.set(true, forKey: Keys.hasAcceptedExperimentNotice)
    }

    func enableExperiment() {
        guard hasAcceptedExperimentNotice else {
            isExperimentEnabled = false
            userDefaults.set(false, forKey: Keys.isExperimentEnabled)
            return
        }

        isExperimentEnabled = true
        userDefaults.set(true, forKey: Keys.isExperimentEnabled)
    }

    func disableExperiment() {
        isExperimentEnabled = false
        userDefaults.set(false, forKey: Keys.isExperimentEnabled)
    }

    func reset() {
        isExperimentEnabled = false
        hasAcceptedExperimentNotice = false
        userDefaults.set(false, forKey: Keys.isExperimentEnabled)
        userDefaults.set(false, forKey: Keys.hasAcceptedExperimentNotice)
    }
}
