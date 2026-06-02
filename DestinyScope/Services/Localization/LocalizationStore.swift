//
//  LocalizationStore.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Combine
import Foundation

final class LocalizationStore: ObservableObject {
    private enum Keys {
        static let languagePreference = "localization.languagePreference"
    }

    @Published private(set) var languagePreference: AppLanguagePreference
    @Published private(set) var currentLanguage: AppLanguage

    private let catalog: LocalizationCatalog
    private let userDefaults: UserDefaults

    init(
        userDefaults: UserDefaults = .standard,
        catalog: LocalizationCatalog = .bundled()
    ) {
        self.userDefaults = userDefaults
        self.catalog = catalog

        let savedPreference = userDefaults.string(forKey: Keys.languagePreference)
            .flatMap(AppLanguagePreference.init(rawValue:)) ?? .system

        languagePreference = savedPreference
        currentLanguage = savedPreference.resolvedLanguage()
    }

    var locale: Locale {
        Locale(identifier: currentLanguage.localeIdentifier)
    }

    func setLanguagePreference(_ preference: AppLanguagePreference) {
        languagePreference = preference
        userDefaults.set(preference.rawValue, forKey: Keys.languagePreference)
        currentLanguage = preference.resolvedLanguage()
    }

    func refreshSystemLanguageIfNeeded() {
        guard languagePreference == .system else {
            return
        }
        currentLanguage = languagePreference.resolvedLanguage()
    }

    func string(_ id: L10nID, replacements: [String: String] = [:]) -> String {
        var value = catalog.string(for: id, language: currentLanguage)
        for (key, replacement) in replacements {
            value = value.replacingOccurrences(of: "{\(key)}", with: replacement)
        }
        return value
    }
}
