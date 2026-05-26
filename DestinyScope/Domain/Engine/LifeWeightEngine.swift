//
//  LifeWeightEngine.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import Foundation

struct LifeWeightEngine {
    private let dataManager: DataManager
    private let repository: LifeWeightRepository

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.repository = LifeWeightRepository(dataManager: dataManager)
    }

    func calculate(birthDate: Date, selectedHour: Int) throws -> LifeWeightResult {
        guard (0...23).contains(selectedHour) else {
            throw LifeWeightError.invalidHour(selectedHour)
        }

        let birthProfile = BirthProfile(solarDate: birthDate, hour: selectedHour)
        let (yearIndex, monthIndex, dateIndex) = dataManager.getChineseCalendarComponents(from: birthDate)
        guard let yearIndex, let monthIndex, let dateIndex else {
            throw LifeWeightError.lunarDateConversionFailed
        }

        var totalWeight = 0.0

        guard let yearInfo = repository.yearInfo(for: yearIndex) else {
            throw LifeWeightError.missingYearInfo(yearIndex)
        }
        totalWeight += yearInfo.weight

        guard let monthInfo = repository.monthInfo(for: monthIndex) else {
            throw LifeWeightError.missingMonthInfo(monthIndex)
        }
        totalWeight += monthInfo.weight

        guard let dateInfo = repository.dateInfo(for: dateIndex) else {
            throw LifeWeightError.missingDateInfo(dateIndex)
        }
        totalWeight += dateInfo.weight

        guard let hourInfo = repository.hourInfo(for: selectedHour) else {
            throw LifeWeightError.missingHourInfo(selectedHour)
        }
        totalWeight += hourInfo.weight

        print("lifeWeight", totalWeight)

        guard let poemInfo = repository.poemInfo(for: totalWeight) else {
            throw LifeWeightError.missingPoemInfo(totalWeight)
        }

        print("poemTitle: \(poemInfo.title)\n, poemContent: \(poemInfo.content)")

        let displayText = yearInfo.yearString + "年" + monthInfo.monthString + dateInfo.dateString + hourInfo.hourString
        let lunarBirthDate = LunarBirthDate(
            yearIndex: yearIndex,
            yearText: yearInfo.yearString,
            month: monthIndex,
            monthText: monthInfo.monthString,
            day: dateIndex,
            dayText: dateInfo.dateString,
            isLeapMonth: false, // TODO: Handle leap lunar months when calendar service is introduced.
            displayText: displayText
        )

        let breakdown = LifeWeightBreakdown(
            year: WeightItem(label: "年", valueText: yearInfo.yearString, weightText: yearInfo.weightString, weight: yearInfo.weight),
            month: WeightItem(label: "月", valueText: monthInfo.monthString, weightText: monthInfo.weightString, weight: monthInfo.weight),
            day: WeightItem(label: "日", valueText: dateInfo.dateString, weightText: dateInfo.weightString, weight: dateInfo.weight),
            hour: WeightItem(label: "时", valueText: hourInfo.hourString, weightText: hourInfo.weightString, weight: hourInfo.weight)
        )

        return LifeWeightResult(
            birthProfile: birthProfile,
            lunarBirthDate: lunarBirthDate,
            hourText: hourInfo.hourString,
            breakdown: breakdown,
            totalWeight: totalWeight,
            totalWeightText: poemInfo.weightString,
            title: poemInfo.title,
            poem: poemInfo.content
        )
    }
}
