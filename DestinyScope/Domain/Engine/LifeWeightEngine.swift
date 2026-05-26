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

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }

    func calculate(birthDate: Date, selectedHour: Int) -> Result? {
        let (yearIndex, monthIndex, dateIndex) = dataManager.getChineseCalendarComponents(from: birthDate)
        guard let yearIndex, let monthIndex, let dateIndex else {
            return nil
        }

        var lunarBirthday = ""
        var totalWeight = 0.0

        if let index = dataManager.yearList.firstIndex(where: { $0.year == yearIndex }) {
            print("yearIndex", index)
            lunarBirthday.append(dataManager.yearList[index].yearString + "年")
            totalWeight += dataManager.yearList[index].weight
        }

        if let index = dataManager.monthList.firstIndex(where: { $0.month == monthIndex }) {
            lunarBirthday.append(dataManager.monthList[index].monthString)
            totalWeight += dataManager.monthList[index].weight
        }

        if let index = dataManager.dateList.firstIndex(where: { $0.date == dateIndex }) {
            lunarBirthday.append(dataManager.dateList[index].dateString)
            totalWeight += dataManager.dateList[index].weight
        }

        if let index = dataManager.hourList.firstIndex(where: { $0.hour == selectedHour }) {
            lunarBirthday.append(dataManager.hourList[index].hourString)
            totalWeight += dataManager.hourList[index].weight
        }

        print("lifeWeight", totalWeight)

        var poemTitle = ""
        var poemContent = ""
        let epsilon: Double = 0.0001
        if let index = dataManager.poemList.firstIndex(where: { abs($0.weight - totalWeight) < epsilon }) {
            poemTitle = dataManager.poemList[index].title
            poemContent = dataManager.poemList[index].content
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
