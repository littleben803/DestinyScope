//
//  FortuneAnswer.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct FortuneAnswer: Equatable {
    let questionTitle: String
    let intent: QuestionIntent
    let answer: String
    let safetyNotice: String
}
