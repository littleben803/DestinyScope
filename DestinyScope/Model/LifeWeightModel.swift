//
//  LifeWeightModel.swift
//  DestinyScope
//
//  Created by phoenix on 2025/4/9.
//

import Foundation

struct YearInfo: Identifiable {
    let id = UUID()
    let year: Int
    let yearString: String
    let weightString: String
    let weight: Double
    let zodiacString: String
    let zodiacImageName: String
    let remarks: String
}

struct MonthInfo: Identifiable {
    let id = UUID()
    let month: Int
    let monthString: String
    let weightString: String
    let weight: Double
    let remarks: String
}

struct DateInfo: Identifiable {
    let id = UUID()
    let date: Int
    let dateString: String
    let weightString: String
    let weight: Double
    let remarks: String
}

struct HourInfo: Identifiable {
    let id = UUID()
    let hour: Int
    let hourString: String
    let weightString: String
    let weight: Double
    let remarks: String
}

struct PoemInfo: Identifiable {
    let id = UUID()
    let weightString: String
    let weight: Double
    let title: String
    let content: String
    let remark1: String
    let remark2: String
}
