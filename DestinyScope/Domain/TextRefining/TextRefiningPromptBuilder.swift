//
//  TextRefiningPromptBuilder.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct TextRefiningPromptBuilder {
    func buildPrompt(from input: TextRefiningInput) throws -> String {
        let sourceText = input.sourceText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !sourceText.isEmpty else {
            throw TextRefiningError.emptyInput
        }

        let contextText = input.context
            .sorted { $0.key < $1.key }
            .map { "\($0.key)：\($0.value)" }
            .joined(separator: "\n")

        let rules = (input.safetyRules.isEmpty ? TextRefiningSafetyRules.defaultRules : input.safetyRules)
            .map { "- \($0)" }
            .joined(separator: "\n")

        return """
        <|im_start|>system
        你是 DestinyScope 的中文文本润色器。你的任务只有“润色表达”，不是算命、预测或咨询。你不能扩写事实，不能新增结论，不能编造四柱、五行、十神、大运、流年。不要使用夸张、恐吓、承诺式表达。不要做绝对预测，不要提供医疗、法律、投资、婚恋或职业确定性建议。只输出一段自然中文，不要输出标题、列表、编号、解释过程或规则。
        <|im_end|>
        <|im_start|>user
        请把原文轻微改写得更自然、温和、清晰。如果原文已经清楚，只做轻微润色。控制在 80 到 180 字，只输出一段，不要重复句子，不要重复免责声明。最后只保留一次安全提示：“\(TextRefiningSafetyRules.safetyNotice)”

        用途：\(input.purpose.rawValue)；语气：\(input.tone.rawValue)。
        参考上下文：\(contextText.isEmpty ? "无" : contextText)
        必须遵守：\(rules.replacingOccurrences(of: "\n", with: " "))
        原文：“\(sourceText)”
        <|im_end|>
        <|im_start|>assistant
        """
    }
}
