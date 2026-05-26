//
//  LifeWeightEngine.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import Foundation

struct LifeWeightEngine {
    struct Result {
        let title: String
        let lunarBirthday: String
        let poemContent: String
        let totalWeight: Double
    }

    private let dataManager: DataManager
    private let repository: LifeWeightRepository

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.repository = LifeWeightRepository(dataManager: dataManager)
    }

    func calculate(birthDate: Date, selectedHour: Int) -> Result? {
        let (yearIndex, monthIndex, dateIndex) = dataManager.getChineseCalendarComponents(from: birthDate)
        guard let yearIndex, let monthIndex, let dateIndex else {
            return nil
        }

        var lunarBirthday = ""
        var totalWeight = 0.0

        if let yearInfo = repository.yearInfo(for: yearIndex) {
            lunarBirthday.append(yearInfo.yearString + "年")
            totalWeight += yearInfo.weight
        }

        if let monthInfo = repository.monthInfo(for: monthIndex) {
            lunarBirthday.append(monthInfo.monthString)
            totalWeight += monthInfo.weight
        }

        if let dateInfo = repository.dateInfo(for: dateIndex) {
            lunarBirthday.append(dateInfo.dateString)
            totalWeight += dateInfo.weight
        }

        if let hourInfo = repository.hourInfo(for: selectedHour) {
            lunarBirthday.append(hourInfo.hourString)
            totalWeight += hourInfo.weight
        }

        print("lifeWeight", totalWeight)

        var poemTitle = ""
        var poemContent = ""
        if let poemInfo = repository.poemInfo(for: totalWeight) {
            poemTitle = poemInfo.title
            poemContent = poemInfo.content
        }

        print("poemTitle: \(poemTitle)\n, poemContent: \(poemContent)")

        return Result(
            title: poemTitle,
            lunarBirthday: lunarBirthday,
            poemContent: poemContent,
            totalWeight: totalWeight
        )
    }
}
