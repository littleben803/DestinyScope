//
//  BirthEightCharactersCalculator.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/3.
//

import Foundation

struct BirthEightCharactersCalculator {
    private static let heavenlyStems = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
    private static let earthlyBranches = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]

    private var gregorianCalendar: Calendar
    private var chineseCalendar: Calendar

    init(timeZone: TimeZone = .current) {
        var gregorianCalendar = Calendar(identifier: .gregorian)
        gregorianCalendar.timeZone = timeZone
        self.gregorianCalendar = gregorianCalendar

        var chineseCalendar = Calendar(identifier: .chinese)
        chineseCalendar.timeZone = timeZone
        self.chineseCalendar = chineseCalendar
    }

    func calculate(solarDate: Date, hour: Int) -> BirthEightCharacters? {
        guard (0...23).contains(hour) else {
            return nil
        }

        let lunarComponents = chineseCalendar.dateComponents([.year, .month], from: solarDate)
        guard
            let lunarYear = lunarComponents.year,
            let lunarMonth = lunarComponents.month
        else {
            return nil
        }

        let yearIndex = positiveModulo(lunarYear - 1, Self.heavenlyStems.count * Self.earthlyBranches.count)
        let yearStemIndex = yearIndex % Self.heavenlyStems.count
        let monthIndex = monthPillarIndex(lunarMonth: lunarMonth, yearStemIndex: yearStemIndex)
        let dayIndex = dayPillarIndex(solarDate: solarDate)
        let hourIndex = hourPillarIndex(hour: hour, dayStemIndex: dayIndex % Self.heavenlyStems.count)

        return BirthEightCharacters(
            yearPillar: pillar(at: yearIndex),
            monthPillar: pillar(at: monthIndex),
            dayPillar: pillar(at: dayIndex),
            hourPillar: pillar(at: hourIndex)
        )
    }

    private func monthPillarIndex(lunarMonth: Int, yearStemIndex: Int) -> Int {
        let firstMonthStemIndex: Int
        switch yearStemIndex {
        case 0, 5:
            firstMonthStemIndex = 2
        case 1, 6:
            firstMonthStemIndex = 4
        case 2, 7:
            firstMonthStemIndex = 6
        case 3, 8:
            firstMonthStemIndex = 8
        default:
            firstMonthStemIndex = 0
        }

        let monthOffset = max(0, lunarMonth - 1)
        let stemIndex = positiveModulo(firstMonthStemIndex + monthOffset, Self.heavenlyStems.count)
        let branchIndex = positiveModulo(2 + monthOffset, Self.earthlyBranches.count)
        return sexagenaryIndex(stemIndex: stemIndex, branchIndex: branchIndex)
    }

    private func dayPillarIndex(solarDate: Date) -> Int {
        let components = gregorianCalendar.dateComponents([.year, .month, .day], from: solarDate)
        guard
            let year = components.year,
            let month = components.month,
            let day = components.day
        else {
            return 0
        }

        let julianDayNumber = julianDayNumber(year: year, month: month, day: day)
        return positiveModulo(julianDayNumber + 49, Self.heavenlyStems.count * Self.earthlyBranches.count)
    }

    private func hourPillarIndex(hour: Int, dayStemIndex: Int) -> Int {
        let branchIndex = hourBranchIndex(hour: hour)
        let firstHourStemIndex: Int
        switch dayStemIndex {
        case 0, 5:
            firstHourStemIndex = 0
        case 1, 6:
            firstHourStemIndex = 2
        case 2, 7:
            firstHourStemIndex = 4
        case 3, 8:
            firstHourStemIndex = 6
        default:
            firstHourStemIndex = 8
        }

        let stemIndex = positiveModulo(firstHourStemIndex + branchIndex, Self.heavenlyStems.count)
        return sexagenaryIndex(stemIndex: stemIndex, branchIndex: branchIndex)
    }

    private func hourBranchIndex(hour: Int) -> Int {
        if hour == 23 {
            return 0
        }
        return ((hour + 1) / 2) % Self.earthlyBranches.count
    }

    private func pillar(at index: Int) -> String {
        let normalizedIndex = positiveModulo(index, Self.heavenlyStems.count * Self.earthlyBranches.count)
        return Self.heavenlyStems[normalizedIndex % Self.heavenlyStems.count]
            + Self.earthlyBranches[normalizedIndex % Self.earthlyBranches.count]
    }

    private func sexagenaryIndex(stemIndex: Int, branchIndex: Int) -> Int {
        for index in 0..<(Self.heavenlyStems.count * Self.earthlyBranches.count) {
            if index % Self.heavenlyStems.count == stemIndex,
               index % Self.earthlyBranches.count == branchIndex {
                return index
            }
        }
        return 0
    }

    private func julianDayNumber(year: Int, month: Int, day: Int) -> Int {
        let a = (14 - month) / 12
        let y = year + 4800 - a
        let m = month + 12 * a - 3
        return day
            + (153 * m + 2) / 5
            + 365 * y
            + y / 4
            - y / 100
            + y / 400
            - 32045
    }

    private func positiveModulo(_ value: Int, _ divisor: Int) -> Int {
        ((value % divisor) + divisor) % divisor
    }
}
