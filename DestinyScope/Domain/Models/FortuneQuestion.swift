//
//  FortuneQuestion.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct FortuneQuestion: Identifiable, Equatable {
    let id: String
    let title: String
    let intent: QuestionIntent
}
