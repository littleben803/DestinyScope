//
//  LlamaCppSession.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

#if canImport(llama)
import llama
#endif

enum LlamaCppSessionError: LocalizedError, Equatable {
    case modelFileMissing([String])
    case llamaFrameworkUnavailable
    case failedToLoadModel(String)
    case failedToGenerate

    var errorDescription: String? {
        switch self {
        case .modelFileMissing(let paths):
            return "未找到本地 GGUF 模型文件：\(paths.joined(separator: "；"))"
        case .llamaFrameworkUnavailable:
            return "llama.cpp framework 尚未接入当前工程。"
        case .failedToLoadModel(let path):
            return "无法加载本地模型：\(path)"
        case .failedToGenerate:
            return "本地模型生成失败。"
        }
    }
}

struct LlamaCppGenerationResult: Equatable {
    let modelInfo: LlamaCppModelInfo
    let output: String
    let loadTime: TimeInterval
    let generateTime: TimeInterval
}

final class LlamaCppSession {
    static var isFrameworkAvailable: Bool {
        #if canImport(llama)
        return true
        #else
        return false
        #endif
    }

    #if canImport(llama)
    private var model: OpaquePointer?
    private var context: OpaquePointer?
    private var vocab: OpaquePointer?
    private var sampler: UnsafeMutablePointer<llama_sampler>?
    private var batch: llama_batch?
    private var currentPosition: Int32 = 0
    private var invalidUTF8Buffer: [CChar] = []
    #endif

    private var modelPath: String?

    deinit {
        unload()
    }

    func loadModel(path: String) throws -> TimeInterval {
        let start = CFAbsoluteTimeGetCurrent()
        guard FileManager.default.fileExists(atPath: path) else {
            throw LlamaCppSessionError.modelFileMissing([path])
        }

        #if canImport(llama)
        unload()
        llama_backend_init()

        var modelParams = llama_model_default_params()
        #if targetEnvironment(simulator)
        modelParams.n_gpu_layers = 0
        #endif

        guard let loadedModel = llama_model_load_from_file(path, modelParams) else {
            throw LlamaCppSessionError.failedToLoadModel(path)
        }

        let threadCount = max(1, min(6, ProcessInfo.processInfo.processorCount - 2))
        var contextParams = llama_context_default_params()
        contextParams.n_ctx = 1024
        contextParams.n_threads = Int32(threadCount)
        contextParams.n_threads_batch = Int32(threadCount)

        guard let loadedContext = llama_init_from_model(loadedModel, contextParams) else {
            llama_model_free(loadedModel)
            throw LlamaCppSessionError.failedToLoadModel(path)
        }

        let samplerParams = llama_sampler_chain_default_params()
        let loadedSampler = llama_sampler_chain_init(samplerParams)
        llama_sampler_chain_add(loadedSampler, llama_sampler_init_temp(0.3))
        llama_sampler_chain_add(loadedSampler, llama_sampler_init_dist(1234))

        model = loadedModel
        context = loadedContext
        vocab = llama_model_get_vocab(loadedModel)
        sampler = loadedSampler
        batch = llama_batch_init(512, 0, 1)
        modelPath = path
        currentPosition = 0
        invalidUTF8Buffer.removeAll()

        return CFAbsoluteTimeGetCurrent() - start
        #else
        modelPath = nil
        _ = start
        throw LlamaCppSessionError.llamaFrameworkUnavailable
        #endif
    }

    func generate(prompt: String, maxTokens: Int = 96) throws -> (text: String, duration: TimeInterval) {
        guard modelPath != nil else {
            throw LlamaCppSessionError.llamaFrameworkUnavailable
        }

        #if canImport(llama)
        guard let context, let vocab, let sampler, var activeBatch = batch else {
            throw LlamaCppSessionError.llamaFrameworkUnavailable
        }

        let start = CFAbsoluteTimeGetCurrent()
        let promptTokens = tokenize(prompt, vocab: vocab, addBOS: true)
        guard !promptTokens.isEmpty else {
            throw LlamaCppSessionError.failedToGenerate
        }

        let contextSize = llama_n_ctx(context)
        guard promptTokens.count + maxTokens <= contextSize else {
            throw LlamaCppSessionError.failedToGenerate
        }

        llama_memory_clear(llama_get_memory(context), true)
        llamaBatchClear(&activeBatch)

        for (index, token) in promptTokens.enumerated() {
            llamaBatchAdd(&activeBatch, token, Int32(index), [0], false)
        }

        activeBatch.logits[Int(activeBatch.n_tokens) - 1] = 1
        guard llama_decode(context, activeBatch) == 0 else {
            batch = activeBatch
            throw LlamaCppSessionError.failedToGenerate
        }

        currentPosition = activeBatch.n_tokens
        invalidUTF8Buffer.removeAll()

        var output = ""
        for _ in 0..<maxTokens {
            let token = llama_sampler_sample(sampler, context, activeBatch.n_tokens - 1)
            if llama_vocab_is_eog(vocab, token) {
                break
            }

            output += stringForToken(token, vocab: vocab)

            llamaBatchClear(&activeBatch)
            llamaBatchAdd(&activeBatch, token, currentPosition, [0], true)
            currentPosition += 1

            guard llama_decode(context, activeBatch) == 0 else {
                batch = activeBatch
                throw LlamaCppSessionError.failedToGenerate
            }
        }

        batch = activeBatch
        let cleanedOutput = output.trimmingCharacters(in: .whitespacesAndNewlines)
        return (cleanedOutput.isEmpty ? "模型未生成可显示文本。" : cleanedOutput, CFAbsoluteTimeGetCurrent() - start)
        #else
        _ = prompt
        _ = maxTokens
        throw LlamaCppSessionError.llamaFrameworkUnavailable
        #endif
    }

    func unload() {
        #if canImport(llama)
        if let sampler {
            llama_sampler_free(sampler)
        }

        if var batch {
            llama_batch_free(batch)
        }

        if let context {
            llama_free(context)
        }

        if let model {
            llama_model_free(model)
        }

        llama_backend_free()
        sampler = nil
        batch = nil
        context = nil
        model = nil
        vocab = nil
        invalidUTF8Buffer.removeAll()
        currentPosition = 0
        #endif

        modelPath = nil
    }

    #if canImport(llama)
    private func tokenize(_ text: String, vocab: OpaquePointer, addBOS: Bool) -> [llama_token] {
        let tokenCapacity = text.utf8.count + (addBOS ? 1 : 0) + 1
        let tokens = UnsafeMutablePointer<llama_token>.allocate(capacity: tokenCapacity)
        defer {
            tokens.deallocate()
        }

        let tokenCount = llama_tokenize(
            vocab,
            text,
            Int32(text.utf8.count),
            tokens,
            Int32(tokenCapacity),
            addBOS,
            false
        )

        guard tokenCount > 0 else {
            return []
        }

        return (0..<Int(tokenCount)).map { tokens[$0] }
    }

    private func stringForToken(_ token: llama_token, vocab: OpaquePointer) -> String {
        let piece = tokenToPiece(token, vocab: vocab)
        invalidUTF8Buffer.append(contentsOf: piece)

        if let string = String(validatingUTF8: invalidUTF8Buffer + [0]) {
            invalidUTF8Buffer.removeAll()
            return string
        }

        return ""
    }

    private func tokenToPiece(_ token: llama_token, vocab: OpaquePointer) -> [CChar] {
        let initialCapacity = 16
        let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: initialCapacity)
        defer {
            buffer.deallocate()
        }

        let written = llama_token_to_piece(vocab, token, buffer, Int32(initialCapacity), 0, false)
        if written < 0 {
            let requiredCapacity = Int(-written)
            let largerBuffer = UnsafeMutablePointer<CChar>.allocate(capacity: requiredCapacity)
            defer {
                largerBuffer.deallocate()
            }

            let largerWritten = llama_token_to_piece(vocab, token, largerBuffer, Int32(requiredCapacity), 0, false)
            guard largerWritten > 0 else {
                return []
            }

            return Array(UnsafeBufferPointer(start: largerBuffer, count: Int(largerWritten)))
        }

        guard written > 0 else {
            return []
        }

        return Array(UnsafeBufferPointer(start: buffer, count: Int(written)))
    }

    private func llamaBatchClear(_ batch: inout llama_batch) {
        batch.n_tokens = 0
    }

    private func llamaBatchAdd(
        _ batch: inout llama_batch,
        _ token: llama_token,
        _ position: llama_pos,
        _ sequenceIDs: [llama_seq_id],
        _ logits: Bool
    ) {
        let index = Int(batch.n_tokens)
        batch.token[index] = token
        batch.pos[index] = position
        batch.n_seq_id[index] = Int32(sequenceIDs.count)

        for sequenceIndex in 0..<sequenceIDs.count {
            batch.seq_id[index]![sequenceIndex] = sequenceIDs[sequenceIndex]
        }

        batch.logits[index] = logits ? 1 : 0
        batch.n_tokens += 1
    }
    #endif
}
