//
//  AppLanguage.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

enum AppLanguage: String, CaseIterable, Codable, Identifiable {
    case simplifiedChinese = "zh-Hans"
    case traditionalChinese = "zh-Hant"
    case english = "en"

    var id: String { rawValue }

    var localeIdentifier: String {
        rawValue
    }

    var displayNameID: L10nID {
        switch self {
        case .simplifiedChinese:
            return .appLanguageSimplifiedChinese
        case .traditionalChinese:
            return .appLanguageTraditionalChinese
        case .english:
            return .appLanguageEnglish
        }
    }

    static func resolved(from preferredLanguages: [String] = Locale.preferredLanguages) -> AppLanguage {
        for identifier in preferredLanguages {
            let normalized = identifier.lowercased()
            if normalized.hasPrefix("zh-hant")
                || normalized.hasPrefix("zh-tw")
                || normalized.hasPrefix("zh-hk")
                || normalized.hasPrefix("zh-mo")
                || normalized.contains("hant") {
                return .traditionalChinese
            }

            if normalized.hasPrefix("zh") {
                return .simplifiedChinese
            }

            if normalized.hasPrefix("en") {
                return .english
            }
        }

        return .simplifiedChinese
    }
}

enum AppLanguagePreference: String, CaseIterable, Codable, Identifiable {
    case system
    case simplifiedChinese
    case traditionalChinese
    case english

    var id: String { rawValue }

    var displayNameID: L10nID {
        switch self {
        case .system:
            return .appLanguageSystem
        case .simplifiedChinese:
            return .appLanguageSimplifiedChinese
        case .traditionalChinese:
            return .appLanguageTraditionalChinese
        case .english:
            return .appLanguageEnglish
        }
    }

    func resolvedLanguage(preferredLanguages: [String] = Locale.preferredLanguages) -> AppLanguage {
        switch self {
        case .system:
            return AppLanguage.resolved(from: preferredLanguages)
        case .simplifiedChinese:
            return .simplifiedChinese
        case .traditionalChinese:
            return .traditionalChinese
        case .english:
            return .english
        }
    }
}
