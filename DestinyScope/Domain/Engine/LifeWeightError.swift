//
//  LifeWeightError.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import Foundation

enum LifeWeightError: LocalizedError {
    case invalidHour(Int)
    case lunarDateConversionFailed
    case missingYearInfo(Int)
    case missingMonthInfo(Int)
    case missingDateInfo(Int)
    case missingHourInfo(Int)
    case missingPoemInfo(Double)

    var errorDescription: String? {
        switch self {
        case .invalidHour:
            return "出生时辰无效，请重新选择。"
        case .lunarDateConversionFailed:
            return "农历日期转换失败，请稍后重试。"
        case .missingYearInfo:
            return "缺少年份命理数据，暂时无法计算。"
        case .missingMonthInfo:
            return "缺少月份命理数据，暂时无法计算。"
        case .missingDateInfo:
            return "缺少日期命理数据，暂时无法计算。"
        case .missingHourInfo:
            return "缺少时辰命理数据，暂时无法计算。"
        case .missingPoemInfo:
            return "缺少对应命格诗文，暂时无法展示结果。"
        }
    }
}
