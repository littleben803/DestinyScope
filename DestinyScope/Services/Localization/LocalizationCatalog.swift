//
//  LocalizationCatalog.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

struct LocalizationCatalog {
    private struct Payload: Decodable {
        let strings: [String: [String: String]]
    }

    private static let moduleNames = [
        "shared",
        "home",
        "knowledge",
        "history",
        "result",
        "settings",
        "legal",
        "onboarding",
        "local_data"
    ]

    private let strings: [String: [String: String]]

    init(strings: [String: [String: String]]) {
        self.strings = strings
    }

    static func bundled(bundle: Bundle = .main) -> LocalizationCatalog {
        var mergedStrings: [String: [String: String]] = [:]
        let decoder = JSONDecoder()

        for moduleName in moduleNames {
            guard let url = bundle.url(forResource: moduleName, withExtension: "json", subdirectory: "Localization")
                ?? bundle.url(forResource: moduleName, withExtension: "json") else {
                assertionFailure("Missing localization module: \(moduleName).json")
                continue
            }

            do {
                let data = try Data(contentsOf: url)
                let payload = try decoder.decode(Payload.self, from: data)

                for (key, value) in payload.strings {
                    if mergedStrings.updateValue(value, forKey: key) != nil {
                        assertionFailure("Duplicate localization key: \(key) in \(moduleName).json")
                    }
                }
            } catch {
                assertionFailure("Failed to load localization module \(moduleName).json: \(error.localizedDescription)")
            }
        }

        return LocalizationCatalog(strings: mergedStrings)
    }

    func string(for id: L10nID, language: AppLanguage) -> String {
        let translations = strings[id.rawValue]
        return translations?[language.rawValue]
            ?? translations?[AppLanguage.simplifiedChinese.rawValue]
            ?? id.rawValue
    }
}
