//
//  TemplateFortuneInterpreter.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import Foundation

struct TemplateFortuneInterpreter: FortuneInterpreting {
    private let safetyNotice = "以上内容仅供娱乐、自我探索和传统文化学习参考，不构成医疗、法律、财务、婚恋或职业决策建议。"

    func interpret(result: LifeWeightResult) -> FortuneInterpretation {
        let focus = strongestItem(in: result.breakdown)

        return FortuneInterpretation(
            summary: summary(for: result),
            personality: personality(for: result, focus: focus),
            career: career(for: result, focus: focus),
            wealth: wealth(for: result, focus: focus),
            relationship: relationship(for: result, focus: focus),
            safetyNotice: safetyNotice
        )
    }

    private func summary(for result: LifeWeightResult) -> String {
        let weightText = result.totalWeightText.isEmpty ? String(format: "%.1f", result.totalWeight) : result.totalWeightText

        switch result.totalWeight {
        case ..<3.0:
            return "\(result.title)（\(weightText)）。从称骨结果看，这类解读更适合作为提醒型参考：可以关注基础积累、节奏管理和长期耐心，把结果用于自我观察，而不是作为固定判断。"
        case 3.0..<5.0:
            return "\(result.title)（\(weightText)）。整体呈现较均衡的参考倾向，适合把注意力放在稳定推进、持续学习和关系经营上。"
        default:
            return "\(result.title)（\(weightText)）。称骨结果显示的文字较积极，可作为自我探索中的鼓励参考；仍建议结合现实环境和个人选择理性看待。"
        }
    }

    private func personality(for result: LifeWeightResult, focus: WeightItem) -> String {
        "性格解读可参考“\(focus.label)”项的权重侧重。你可能更适合从\(focus.valueText)所代表的节奏里观察自己：遇事可以关注稳定性、表达方式和执行耐心。原诗文可作为传统文本背景，不建议按字面作绝对判断。"
    }

    private func career(for result: LifeWeightResult, focus: WeightItem) -> String {
        switch focus.label {
        case "年":
            return "事业方面可参考年项权重较突出的倾向：更适合重视长期规划、资源积累和阶段目标。建议把方向拆小，逐步验证。"
        case "月":
            return "事业方面可参考月项权重较突出的倾向：可以关注环境变化、学习节奏和协作关系。遇到选择时，建议先看可持续性。"
        case "日":
            return "事业方面可参考日项权重较突出的倾向：个人行动和日常习惯可能更值得关注。建议把精力放在稳定输出和可复盘的进步上。"
        default:
            return "事业方面可参考时辰项权重较突出的倾向：行动时机和执行节奏可能比较关键。建议减少冲动决策，保留调整空间。"
        }
    }

    private func wealth(for result: LifeWeightResult, focus: WeightItem) -> String {
        "财运部分仅作传统文化参考，不代表收益预测。结合当前总重量 \(String(format: "%.1f", result.totalWeight))，建议关注稳健管理、量入为出和风险边界，不宜把命理解读作为投资依据。"
    }

    private func relationship(for result: LifeWeightResult, focus: WeightItem) -> String {
        "关系方面可以把解读用于自我观察：关注沟通方式、情绪表达和彼此边界。若诗文中有较强烈的说法，也建议转化为温和提醒，不作婚恋结果的绝对判断。"
    }

    private func strongestItem(in breakdown: LifeWeightBreakdown) -> WeightItem {
        [breakdown.year, breakdown.month, breakdown.day, breakdown.hour]
            .max(by: { $0.weight < $1.weight }) ?? breakdown.year
    }
}
