//
//  LifeWeightReadingRepository.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

final class LifeWeightReadingRepository {
    private let loader: JSONResourceLoader
    private var cachedCatalog: LifeWeightReadingCatalog?

    init(loader: JSONResourceLoader = JSONResourceLoader()) {
        self.loader = loader
    }

    func loadCatalog() throws -> LifeWeightReadingCatalog {
        if let cachedCatalog {
            return cachedCatalog
        }

        let catalog: LifeWeightReadingCatalog
        do {
            catalog = try loader.load(
                LifeWeightReadingCatalog.self,
                named: "life_weight_readings",
                subdirectory: "Readings"
            )
        } catch JSONResourceLoaderError.fileNotFound {
            catalog = try loader.load(
                LifeWeightReadingCatalog.self,
                named: "life_weight_readings"
            )
        }
        cachedCatalog = catalog
        return catalog
    }

    func reading(forWeightKey weightKey: String, gender: BirthGender) throws -> LifeWeightReading? {
        try loadCatalog().reading(forWeightKey: weightKey, gender: gender)
    }
}
