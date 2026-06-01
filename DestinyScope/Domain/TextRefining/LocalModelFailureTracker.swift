//
//  LocalModelFailureTracker.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct LocalModelFailureTracker {
    private enum Keys {
        static let consecutiveFailureCount = "localModelRuntime.consecutiveFailureCount"
        static let lastFailureDate = "localModelRuntime.lastFailureDate"
    }

    let maxFailureCount: Int
    private let userDefaults: UserDefaults

    init(
        maxFailureCount: Int = 3,
        userDefaults: UserDefaults = .standard
    ) {
        self.maxFailureCount = maxFailureCount
        self.userDefaults = userDefaults
    }

    var consecutiveFailureCount: Int {
        userDefaults.integer(forKey: Keys.consecutiveFailureCount)
    }

    var lastFailureDate: Date? {
        userDefaults.object(forKey: Keys.lastFailureDate) as? Date
    }

    func resetOnSuccess() {
        userDefaults.set(0, forKey: Keys.consecutiveFailureCount)
        userDefaults.removeObject(forKey: Keys.lastFailureDate)
    }

    func recordFailure() {
        userDefaults.set(consecutiveFailureCount + 1, forKey: Keys.consecutiveFailureCount)
        userDefaults.set(Date(), forKey: Keys.lastFailureDate)
    }

    func shouldBlockTemporarily() -> Bool {
        consecutiveFailureCount >= maxFailureCount
    }
}
