//
//  OnboardingPage.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct OnboardingPage: Identifiable, Equatable {
    let id: Int
    let systemImageName: String
    let title: String
    let body: String
}

extension OnboardingPage {
    static let v1_6Pages: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            systemImageName: "sparkles",
            title: "东方命理 · 自我探索",
            body: "DestinyScope 基于传统命理文化和本地模板解读，帮助你以轻松方式了解称骨结果、命格诗文和相关知识。"
        ),
        OnboardingPage(
            id: 1,
            systemImageName: "lock.shield",
            title: "出生信息仅在本机处理",
            body: "出生日期和时辰只用于设备端本地计算，不需要账号、不上传、不接服务端。历史记录也仅保存在当前设备，可随时删除。"
        ),
        OnboardingPage(
            id: 2,
            systemImageName: "leaf",
            title: "结果仅供参考",
            body: "命理结果适合娱乐、自我探索和传统文化学习参考，不构成医疗、法律、财务、投资、婚恋或职业决策建议。"
        ),
        OnboardingPage(
            id: 3,
            systemImageName: "book.closed",
            title: "学习、保存与回看",
            body: "你可以浏览知识库了解传统文化，也可以在本机保存历史查询记录，方便之后回看。"
        )
    ]
}

