//
//  DataManager.swift
//  DestinyScope
//
//  Created by phoenix on 2025/4/9.
//

import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()

    @Published var yearList: [YearInfo] = []
    @Published var monthList: [MonthInfo] = []
    @Published var dateList: [DateInfo] = []
    @Published var hourList: [HourInfo] = []
    @Published var poemList: [PoemInfo] = []

    private init() {
        loadAllData()
    }

    private func loadAllData() {
        yearList = loadCSV(named: "Year", parser: parseYearRow)
        monthList = loadCSV(named: "Month", parser: parseMonthRow)
        dateList = loadCSV(named: "Date", parser: parseDateRow)
        hourList = loadCSV(named: "Hour", parser: parseHourRow)
        poemList = loadCSV(named: "Poem", parser: parsePoemRow)
    }

    private func loadCSV<T>(named name: String, parser: ([String]) -> T?) -> [T] {
        guard let url = Bundle.main.url(forResource: name, withExtension: "csv"),
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            print("❌ 无法加载 \(name).csv")
            return []
        }

        let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        let dataLines = lines.dropFirst() // 跳过 header

        return dataLines.compactMap { line in
            let parts = line.components(separatedBy: ",")
            return parser(parts)
        }
    }
    
    private func parseYearRow(_ parts: [String]) -> YearInfo? {
        guard parts.count >= 7,
              let year = Int(parts[0]),
              let weight = Double(parts[3]) else { return nil }

        return YearInfo(
            year: year,
            yearString: parts[1],
            weightString: parts[2],
            weight: weight,
            zodiacString: parts[4],
            zodiacImageName: parts[5],
            remarks: parts[6]
        )
    }

    private func parseMonthRow(_ parts: [String]) -> MonthInfo? {
        guard parts.count >= 5,
              let month = Int(parts[0]),
              let weight = Double(parts[3]) else { return nil }

        return MonthInfo(
            month: month,
            monthString: parts[1],
            weightString: parts[2],
            weight: weight,
            remarks: parts[4]
        )
    }

    private func parseDateRow(_ parts: [String]) -> DateInfo? {
        guard parts.count >= 5,
              let date = Int(parts[0]),
              let weight = Double(parts[3]) else { return nil }

        return DateInfo(
            date: date,
            dateString: parts[1],
            weightString: parts[2],
            weight: weight,
            remarks: parts[4]
        )
    }

    private func parseHourRow(_ parts: [String]) -> HourInfo? {
        guard parts.count >= 5,
              let hour = Int(parts[0]),
              let weight = Double(parts[3]) else { return nil }

        return HourInfo(
            hour: hour,
            hourString: parts[1],
            weightString: parts[2],
            weight: weight,
            remarks: parts[4]
        )
    }

    private func parsePoemRow(_ parts: [String]) -> PoemInfo? {
        guard parts.count >= 6,
              let weight = Double(parts[1]) else { return nil }

        return PoemInfo(
            weightString: parts[0],
            weight: weight,
            title: parts[2],
            content: parts[3].unescaped(),
            remark1: parts[4],
            remark2: parts[5]
        )
    }
}

// MARK: 对外接口
extension DataManager {
    // 获取中国农历日期
    public func getChineseCalendarComponents(from date: Date) -> (year: Int?, month: Int?, day: Int?) {
        let chineseCalendar = Calendar(identifier: .chinese)
        let components = chineseCalendar.dateComponents([.year, .month, .day], from: date)
        return (components.year, components.month, components.day)
    }
}

extension String {
    func unescaped() -> String {
        self
            .replacingOccurrences(of: "\\n", with: "\n")
            .replacingOccurrences(of: "\\t", with: "\t")
            .replacingOccurrences(of: "\\\"", with: "\"")
            .replacingOccurrences(of: "\\\\", with: "\\")
    }
}
