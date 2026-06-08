//
//  RAGContextBuilder.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/8.
//

import Foundation

struct RAGContextBuilder {
    private let maxContextLength: Int
    private let minChunkLength: Int
    private let maxChunkLength: Int

    init(maxContextLength: Int = 850, minChunkLength: Int = 80, maxChunkLength: Int = 180) {
        self.maxContextLength = maxContextLength
        self.minChunkLength = minChunkLength
        self.maxChunkLength = maxChunkLength
    }

    func buildContext(from chunks: [KnowledgeChunk]) -> String {
        guard !chunks.isEmpty else {
            return "【知识片段】\n暂无可用知识片段。"
        }

        var lines: [String] = []
        var seenFingerprints = Set<String>()

        for chunk in chunks {
            let text = normalizedText(from: chunk)
            let fingerprint = String(text.prefix(36))
            guard !fingerprint.isEmpty, !seenFingerprints.contains(fingerprint) else {
                continue
            }

            seenFingerprints.insert(fingerprint)

            let clipped = clippedText(text)
            let candidateLine = "\(lines.count + 1). \(clipped)"
            let candidate = (["【知识片段】"] + lines + [candidateLine]).joined(separator: "\n")
            guard candidate.count <= maxContextLength else {
                break
            }

            lines.append(candidateLine)
        }

        if lines.isEmpty {
            return "【知识片段】\n暂无可用知识片段。"
        }

        return (["【知识片段】"] + lines).joined(separator: "\n")
    }
}

private extension RAGContextBuilder {
    func normalizedText(from chunk: KnowledgeChunk) -> String {
        chunk.text
            .replacingOccurrences(of: "\r", with: "\n")
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "参考解读：", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func clippedText(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count > maxChunkLength else {
            return trimmed
        }

        let prefix = trimmed.prefix(maxChunkLength)
        let sentenceEndings = CharacterSet(charactersIn: "。！？!?；;")
        if let lastSentenceEnd = prefix.lastIndex(where: { character in
            String(character).rangeOfCharacter(from: sentenceEndings) != nil
        }) {
            let sentenceClipped = String(prefix[...lastSentenceEnd])
            if sentenceClipped.count >= minChunkLength {
                return sentenceClipped
            }
        }

        return String(prefix) + "…"
    }
}
