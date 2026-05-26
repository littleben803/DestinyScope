//
//  LifeWeightRepository.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import Foundation

struct LifeWeightRepository {
    private let dataManager: DataManager
    private let epsilon: Double = 0.0001

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }

    func yearInfo(for yearIndex: Int) -> YearInfo? {
        dataManager.yearList.first(where: { $0.year == yearIndex })
    }

    func monthInfo(for month: Int) -> MonthInfo? {
        dataManager.monthList.first(where: { $0.month == month })
    }

    func dateInfo(for day: Int) -> DateInfo? {
        dataManager.dateList.first(where: { $0.date == day })
    }

    func hourInfo(for hour: Int) -> HourInfo? {
        dataManager.hourList.first(where: { $0.hour == hour })
    }

    func poemInfo(for totalWeight: Double) -> PoemInfo? {
        dataManager.poemList.first(where: { abs($0.weight - totalWeight) < epsilon })
    }
}
