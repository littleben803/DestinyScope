//
//  LifeWeightInsightGenerator.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct LifeWeightInsightGenerator {
    private let safetyNotice = "洞察内容仅供娱乐、自我探索和传统文化学习参考，不构成医疗、法律、财务、投资、婚恋或职业决策建议。"

    func generate(result: LifeWeightResult) -> LifeWeightInsight {
        let focus = strongestItem(in: result.breakdown)

        return LifeWeightInsight(
            tags: tags(for: result, focus: focus),
            focusTitle: focusTitle(for: focus),
            focusDescription: focusDescription(for: result, focus: focus),
            strengths: strengths(for: result, focus: focus),
            cautions: cautions(for: result, focus: focus),
            actionSuggestion: actionSuggestion(for: result, focus: focus),
            safetyNotice: safetyNotice
        )
    }

    private func tags(for result: LifeWeightResult, focus: WeightItem) -> [String] {
        var tags: [String]

        switch result.totalWeight {
        case ..<3.0:
            tags = ["稳定积累", "自我修炼"]
        case 3.0..<5.0:
            tags = ["重视规划", "长期主义"]
        default:
            tags = ["行动力", "稳中求进"]
        }

        switch focus.label {
        case "年":
            tags.append("长期视角")
        case "月":
            tags.append("环境适应")
        case "日":
            tags.append("日常精进")
        default:
            tags.append("节奏管理")
        }

        return Array(tags.prefix(3))
    }

    private func focusTitle(for focus: WeightItem) -> String {
        switch focus.label {
        case "年":
            return "权重侧重点：长期规划"
        case "月":
            return "权重侧重点：环境节奏"
        case "日":
            return "权重侧重点：日常行动"
        default:
            return "权重侧重点：时机把握"
        }
    }

    private func focusDescription(for result: LifeWeightResult, focus: WeightItem) -> String {
        "当前报告中“\(focus.label)”项权重相对突出（\(focus.valueText)，\(focus.weightText)）。这可以作为观察重点，帮助你从\(focusAxis(for: focus))的角度理解 \(result.title) 与 \(result.totalWeightText) 的参考含义。"
    }

    private func strengths(for result: LifeWeightResult, focus: WeightItem) -> [String] {
        var items: [String]

        switch result.totalWeight {
        case ..<3.0:
            items = [
                "适合把注意力放在基础积累和稳定节奏上。",
                "面对变化时，可以通过持续复盘提升确定感。"
            ]
        case 3.0..<5.0:
            items = [
                "整体倾向较均衡，适合用长期目标带动日常行动。",
                "在学习、协作和个人规划之间较适合保持稳定连接。"
            ]
        default:
            items = [
                "报告文字较积极，可作为自我探索中的鼓励参考。",
                "适合把行动力转化为可持续的计划和阶段成果。"
            ]
        }

        items.append(strengthForFocus(focus))
        return items
    }

    private func cautions(for result: LifeWeightResult, focus: WeightItem) -> [String] {
        [
            "称骨结果适合作为传统文化参考，不建议按字面做固定判断。",
            "涉及现实选择时，仍需要结合环境、资源和个人意愿综合判断。",
            cautionForFocus(focus)
        ]
    }

    private func actionSuggestion(for result: LifeWeightResult, focus: WeightItem) -> String {
        "建议把“\(result.title)”作为自我观察的起点：先记录近期最想推进的一件事，再围绕\(focusAction(for: focus))设定一个可执行的小目标，并在一到两周后复盘。"
    }

    private func strongestItem(in breakdown: LifeWeightBreakdown) -> WeightItem {
        [breakdown.year, breakdown.month, breakdown.day, breakdown.hour]
            .max(by: { $0.weight < $1.weight }) ?? breakdown.year
    }

    private func focusAxis(for focus: WeightItem) -> String {
        switch focus.label {
        case "年":
            return "长期方向和阶段积累"
        case "月":
            return "外部环境和学习节奏"
        case "日":
            return "个人习惯和日常选择"
        default:
            return "行动时机和执行节奏"
        }
    }

    private func strengthForFocus(_ focus: WeightItem) -> String {
        switch focus.label {
        case "年":
            return "年项突出时，可以更重视长期规划、资源整理和阶段目标。"
        case "月":
            return "月项突出时，可以更重视环境适应、学习节奏和协作关系。"
        case "日":
            return "日项突出时，可以更重视日常习惯、稳定输出和持续改善。"
        default:
            return "时项突出时，可以更重视行动节奏、启动时机和调整空间。"
        }
    }

    private func cautionForFocus(_ focus: WeightItem) -> String {
        switch focus.label {
        case "年":
            return "长期规划不宜过度僵化，可以保留随阶段调整的空间。"
        case "月":
            return "关注环境变化时，也要避免过度受外界评价牵动。"
        case "日":
            return "强调日常行动时，需要避免把短期波动放大成长期结论。"
        default:
            return "关注时机时，需要避免把犹豫误认为等待，把冲动误认为果断。"
        }
    }

    private func focusAction(for focus: WeightItem) -> String {
        switch focus.label {
        case "年":
            return "长期规划"
        case "月":
            return "环境适应"
        case "日":
            return "日常习惯"
        default:
            return "执行节奏"
        }
    }
}
