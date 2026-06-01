//
//  LocalModelDebugView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

#if DEBUG
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct LocalModelDebugView: View {
    @State private var modelStatuses: [LocalModelFileStatus] = []
    @State private var fileCheckTime: TimeInterval?
    @State private var loadTime: TimeInterval?
    @State private var generateTime: TimeInterval?
    @State private var outputText = "尚未生成"
    @State private var errorMessage: String?
    @State private var isRunning = false
    @State private var refinedText = "尚未润色"
    @State private var refineEngine = "未运行"
    @State private var refineWasRefined = false
    @State private var refineSafetyNotice = "未记录"
    @State private var refineTime: TimeInterval?
    @State private var refineErrorMessage: String?
    @State private var didFallbackToTemplate = false
    @State private var selectedTestCase = TextRefiningTestSuite.debugCases[0]
    @State private var safetyCheckSummary = "未运行"
    @State private var matchedRiskTerms = "无"
    @State private var selectedBenchmarkCase = LocalModelBenchmarkSuite.debugCases[0]
    @State private var benchmarkResults: [LocalModelBenchmarkResult] = []
    @State private var benchmarkErrorMessage: String?
    @State private var benchmarkSummary = "尚未运行"
    @State private var isModelImporterPresented = false
    @State private var importStatusMessage = "尚未导入"
    @State private var importedModelPath = "未记录"
    @State private var importedModelSize = "未知"

    private let config = LocalModelDebugConfig.current

    private var isSimulator: Bool {
        DeviceModelIdentifier.isRunningOnSimulator
    }

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    AppSectionHeader(title: "V1.2 本地模型 PoC")

                    AppCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            infoRow(title: "运行环境", value: isSimulator ? "模拟器：直接读取 Mac 本地模型路径" : "真机：需要手动导入模型到 App Documents")
                            infoRow(title: "当前默认输出", value: "TemplateTextRefiner")
                            infoRow(title: "推荐模型", value: "Qwen2.5-0.5B-Instruct GGUF 4-bit")
                            infoRow(title: "llama.xcframework", value: config.llamaFrameworkExists() ? "已配置" : "未找到")
                            infoRow(title: "framework 路径", value: config.llamaFrameworkPath)
                            if isSimulator {
                                infoRow(title: "Mac 主路径", value: config.primaryModelPath)
                                infoRow(title: "Mac 备用路径", value: config.fallbackModelPath)
                            } else {
                                infoRow(title: "App Documents 目标路径", value: config.appDocumentsModelFileURL().path)
                            }
                            infoRow(title: "文件位置", value: config.modelDirectoryDescription)
                        }
                    }

                    AppCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("当前实验入口只在 Debug 下可见，不影响默认 App 输出。模型文件不会提交仓库，也不会复制进 App Bundle。")
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)

                            Text("如果 llama.cpp framework 尚未接入，加载测试会显示明确错误并保持 App 可编译。")
                                .font(AppTheme.Typography.secondary)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                        }
                    }

                    if !isSimulator {
                        AppPrimaryButton(title: "检查模型文件") {
                            checkModelFiles()
                        }
                        .disabled(isRunning)

                        importCard
                    } else {
                        simulatorModelCard
                    }

                    AppPrimaryButton(title: isRunning ? "加载中..." : "加载并生成测试文本") {
                        runGenerationTest()
                    }
                    .disabled(isRunning)

                    statusCard

                    refiningCard

                    benchmarkCard
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("本地模型 PoC")
        .fileImporter(
            isPresented: $isModelImporterPresented,
            allowedContentTypes: [UTType(filenameExtension: "gguf") ?? .data],
            allowsMultipleSelection: false
        ) { result in
            handleModelImport(result)
        }
        .onAppear {
            checkModelFiles()
        }
    }

    private var importCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("导入 GGUF 模型")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text("仅用于 Debug 真机测试。选择 Files App 中的 .gguf 文件后，会复制到 App Documents/LocalModels/DestinyScope/，不会上传，也不会加入 App Bundle。")
                    .font(AppTheme.Typography.secondary)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                AppPrimaryButton(title: "导入 GGUF 模型") {
                    isModelImporterPresented = true
                }
                .disabled(isRunning)

                infoRow(title: "导入状态", value: importStatusMessage)
                infoRow(title: "导入路径", value: importedModelPath)
                infoRow(title: "导入文件大小", value: importedModelSize)
                infoRow(title: "Documents 模型是否存在", value: config.modelExistsInAppDocuments() ? "存在" : "未找到")
            }
        }
    }

    private var simulatorModelCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("模拟器模型路径")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text("当前为模拟器，PoC 会直接读取 Mac 本地指定路径的 GGUF 文件，不需要检查按钮，也不需要导入模型。")
                    .font(AppTheme.Typography.secondary)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                let status = config.currentModelFileStatuses().first
                infoRow(title: "当前路径", value: status?.resolvedURL?.path ?? config.primaryModelPath)
                infoRow(title: "文件状态", value: status?.isUsable == true ? "可用" : "未找到或不可用")
                infoRow(title: "文件大小", value: status?.fileSizeText ?? "未知")
            }
        }
    }

    private var refiningCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("TextRefining 润色测试")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text("安全测试样例")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                ForEach(TextRefiningTestSuite.debugCases) { testCase in
                    Button {
                        selectedTestCase = testCase
                        resetRefiningState()
                    } label: {
                        HStack {
                            Text(testCase.title)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            Spacer()
                            if selectedTestCase.id == testCase.id {
                                Text("当前")
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.Colors.darkGold)
                            }
                        }
                        .padding(.vertical, AppTheme.Spacing.xs)
                    }
                    .buttonStyle(.plain)
                }

                infoRow(title: "测试名称", value: selectedTestCase.title)
                infoRow(title: "sourceText", value: selectedTestCase.sourceText)

                AppPrimaryButton(title: isRunning ? "润色中..." : "调用 TextRefining.refine") {
                    runTextRefiningTest()
                }
                .disabled(isRunning)

                infoRow(title: "refinedText", value: refinedText)
                infoRow(title: "engine", value: refineEngine)
                infoRow(title: "wasRefined", value: refineWasRefined ? "true" : "false")
                infoRow(title: "safetyNotice", value: refineSafetyNotice)
                infoRow(title: "耗时", value: formatDuration(refineTime))
                infoRow(title: "回退状态", value: didFallbackToTemplate ? "已回退到模板文本" : "未回退")
                infoRow(title: "safety check", value: safetyCheckSummary)
                infoRow(title: "风险原因", value: matchedRiskTerms)

                if let refineErrorMessage {
                    Text("错误信息")
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(refineErrorMessage)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.cinnabar)
                }
            }
        }
    }

    private var benchmarkCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("设备性能测试")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text("仅用于 Debug 手工测试；结果不会上传，也不会写入远程日志。内存峰值、CPU、耗电和温度仍需用 Xcode Instruments 人工观察。")
                    .font(AppTheme.Typography.secondary)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                infoRow(title: "设备", value: deviceName)
                infoRow(title: "系统", value: systemVersion)
                infoRow(title: "模型文件", value: selectedModelFileName)
                infoRow(title: "模型大小", value: selectedModelFileSizeDescription)

                Text("测试样例")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                ForEach(LocalModelBenchmarkSuite.debugCases) { testCase in
                    Button {
                        selectedBenchmarkCase = testCase
                        benchmarkErrorMessage = nil
                    } label: {
                        HStack {
                            Text(testCase.title)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            Spacer()
                            if selectedBenchmarkCase.id == testCase.id {
                                Text("当前")
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.Colors.darkGold)
                            }
                        }
                        .padding(.vertical, AppTheme.Spacing.xs)
                    }
                    .buttonStyle(.plain)
                }

                HStack(spacing: AppTheme.Spacing.md) {
                    AppPrimaryButton(title: isRunning ? "运行中..." : "运行当前") {
                        runBenchmark(selectedBenchmarkCase)
                    }
                    .disabled(isRunning)

                    AppPrimaryButton(title: isRunning ? "运行中..." : "运行全部") {
                        runAllBenchmarks()
                    }
                    .disabled(isRunning)
                }

                AppPrimaryButton(title: "复制结果摘要") {
                    UIPasteboard.general.string = benchmarkSummaryText()
                    benchmarkSummary = "已复制结果摘要"
                }
                .disabled(benchmarkResults.isEmpty)

                infoRow(title: "状态", value: benchmarkSummary)

                if let benchmarkErrorMessage {
                    Text("错误信息")
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(benchmarkErrorMessage)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.cinnabar)
                }

                if benchmarkResults.isEmpty {
                    Text("尚无 benchmark 结果。")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                } else {
                    ForEach(benchmarkResults) { result in
                        benchmarkResultView(result)
                    }
                }
            }
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(title)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)

            Text(value)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
        }
    }

    private var statusCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("模型文件状态")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                if modelStatuses.isEmpty {
                    Text("尚未检查。")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                } else {
                    ForEach(modelStatuses) { status in
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text(status.displayPath)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)

                            Text(status.exists ? "存在，大小 \(status.sizeDescription)" : "未找到")
                                .font(AppTheme.Typography.secondary)
                                .foregroundColor(status.exists ? AppTheme.Colors.darkGold : AppTheme.Colors.secondaryText)
                        }
                    }
                }

                infoRow(title: "文件检查耗时", value: formatDuration(fileCheckTime))
                infoRow(title: "加载耗时", value: formatDuration(loadTime))
                infoRow(title: "生成耗时", value: formatDuration(generateTime))

                Text("输出文本")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text(outputText)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                if let errorMessage {
                    Text("错误信息")
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(errorMessage)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.cinnabar)
                }
            }
        }
    }

    private func checkModelFiles() {
        let start = CFAbsoluteTimeGetCurrent()
        modelStatuses = config.currentModelFileStatuses()
        fileCheckTime = CFAbsoluteTimeGetCurrent() - start
    }

    private func handleModelImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let sourceURL = urls.first else {
                importStatusMessage = "未选择文件"
                return
            }

            do {
                let destinationURL = try LocalModelFileImporter().importModel(from: sourceURL)
                importedModelPath = destinationURL.path
                importedModelSize = fileSizeDescription(at: destinationURL)
                importStatusMessage = "导入成功，已覆盖旧文件（如存在）。"
                checkModelFiles()
            } catch {
                importedModelPath = "未导入"
                importedModelSize = "未知"
                importStatusMessage = (error as? LocalizedError)?.errorDescription ?? "导入失败。"
                checkModelFiles()
            }
        case .failure(let error):
            importedModelPath = "未导入"
            importedModelSize = "未知"
            importStatusMessage = (error as? LocalizedError)?.errorDescription ?? "导入取消或失败。"
        }
    }

    private func runGenerationTest() {
        isRunning = true
        errorMessage = nil
        outputText = "测试中..."
        loadTime = nil
        generateTime = nil
        checkModelFiles()

        Task {
            let output: String
            let errorText: String?
            let measuredLoadTime: TimeInterval?
            let measuredGenerateTime: TimeInterval?
            let loadedModelStatus: LocalModelFileStatus?

            do {
                let result = try LocalLlamaTextRefiner(config: config).runDebugGeneration()
                output = result.output
                errorText = nil
                measuredLoadTime = result.loadTime
                measuredGenerateTime = result.generateTime
                loadedModelStatus = config.modelFileStatus(for: result.modelInfo.path)
            } catch TextRefiningError.localModelNotAvailable {
                output = "未生成"
                errorText = "本地模型尚未配置。"
                measuredLoadTime = nil
                measuredGenerateTime = nil
                loadedModelStatus = nil
            } catch {
                output = "未生成"
                errorText = (error as? LocalizedError)?.errorDescription ?? "接口测试失败。"
                measuredLoadTime = nil
                measuredGenerateTime = nil
                loadedModelStatus = nil
            }

            await MainActor.run {
                outputText = output
                errorMessage = errorText
                loadTime = measuredLoadTime
                generateTime = measuredGenerateTime
                if let loadedModelStatus {
                    modelStatuses = [loadedModelStatus]
                } else {
                    modelStatuses = config.currentModelFileStatuses()
                }
                isRunning = false
            }
        }
    }

    private func runTextRefiningTest() {
        isRunning = true
        refineErrorMessage = nil
        refinedText = "测试中..."
        refineEngine = "运行中"
        refineWasRefined = false
        refineSafetyNotice = "未记录"
        refineTime = nil
        didFallbackToTemplate = false
        safetyCheckSummary = "未运行"
        matchedRiskTerms = "无"

        let input = TextRefiningInput(
            sourceText: selectedTestCase.sourceText,
            purpose: selectedTestCase.purpose,
            tone: selectedTestCase.tone,
            context: [
                "场景": "DestinyScope V1.2 Debug-only TextRefining PoC",
                "边界": "只能润色既有模板文本，不进入默认结果页"
            ],
            safetyRules: TextRefiningSafetyRules.defaultRules
        )

        Task {
            let start = CFAbsoluteTimeGetCurrent()
            let output: TextRefiningOutput
            let errorText: String?
            let fallbackUsed: Bool
            let safetyResult: TextRefiningSafetyCheckResult

            do {
                output = try await TextRefinerFactory.makeDebugLocalLlamaRefiner().refine(input)
                safetyResult = TextRefiningSafetyChecker().check(output.text, sourceText: input.sourceText)
                errorText = output.engine.contains("fallback") ? output.safetyNotice : nil
                fallbackUsed = output.engine.contains("fallback")
            } catch {
                output = (try? await TextRefinerFactory.makeTemplateRefiner().refine(input)) ?? TextRefiningOutput(
                    text: input.sourceText,
                    wasRefined: false,
                    engine: "template",
                    safetyNotice: TextRefiningSafetyRules.safetyNotice
                )
                errorText = (error as? LocalizedError)?.errorDescription ?? "TextRefining 测试失败，已回退到模板文本。"
                fallbackUsed = true
                safetyResult = TextRefiningSafetyChecker().check(output.text, sourceText: input.sourceText)
            }

            let elapsed = CFAbsoluteTimeGetCurrent() - start

            await MainActor.run {
                refinedText = output.text
                refineEngine = output.engine
                refineWasRefined = output.wasRefined
                refineSafetyNotice = output.safetyNotice ?? "未记录"
                refineTime = elapsed
                refineErrorMessage = errorText
                didFallbackToTemplate = fallbackUsed
                safetyCheckSummary = safetyResult.isPassed ? "通过" : "未通过"
                matchedRiskTerms = safetyResult.reasonText
                isRunning = false
            }
        }
    }

    private func runBenchmark(_ testCase: LocalModelBenchmarkCase) {
        isRunning = true
        benchmarkErrorMessage = nil
        benchmarkSummary = "运行中：\(testCase.title)"
        checkModelFiles()

        Task {
            let result = await makeBenchmarkResult(for: testCase)

            await MainActor.run {
                benchmarkResults.insert(result, at: 0)
                benchmarkSummary = "已完成：\(testCase.title)"
                benchmarkErrorMessage = result.errorMessage
                isRunning = false
            }
        }
    }

    private func runAllBenchmarks() {
        isRunning = true
        benchmarkErrorMessage = nil
        benchmarkSummary = "批量运行中..."
        checkModelFiles()

        Task {
            var results: [LocalModelBenchmarkResult] = []
            for testCase in LocalModelBenchmarkSuite.debugCases {
                results.append(await makeBenchmarkResult(for: testCase))
            }

            await MainActor.run {
                benchmarkResults = results.reversed() + benchmarkResults
                benchmarkSummary = "已完成 \(results.count) 条 benchmark"
                benchmarkErrorMessage = results.first(where: { $0.errorMessage != nil })?.errorMessage
                isRunning = false
            }
        }
    }

    private func makeBenchmarkResult(for testCase: LocalModelBenchmarkCase) async -> LocalModelBenchmarkResult {
        let start = CFAbsoluteTimeGetCurrent()
        let modelInfo = currentModelInfo()

        do {
            let debugResult = try await LocalLlamaTextRefiner(config: config).refineWithDebugMetrics(testCase.input)
            let totalTime = CFAbsoluteTimeGetCurrent() - start
            let didFallback = !debugResult.output.wasRefined || debugResult.output.engine.contains("fallback")

            return LocalModelBenchmarkResult(
                deviceName: deviceName,
                systemVersion: systemVersion,
                modelFileName: modelInfo.fileName,
                modelFileSize: modelInfo.fileSize,
                testName: testCase.title,
                loadTime: debugResult.loadTime,
                generationTime: debugResult.generationTime,
                totalTime: totalTime,
                outputCharacterCount: debugResult.output.text.count,
                didFallback: didFallback,
                errorMessage: didFallback ? debugResult.output.safetyNotice : nil,
                notes: testCase.expectedFallback ? "高风险样例，预期应回退。" : "普通样例，观察耗时和输出稳定性。",
                outputPreview: String(debugResult.output.text.prefix(120))
            )
        } catch {
            let totalTime = CFAbsoluteTimeGetCurrent() - start
            return LocalModelBenchmarkResult(
                deviceName: deviceName,
                systemVersion: systemVersion,
                modelFileName: modelInfo.fileName,
                modelFileSize: modelInfo.fileSize,
                testName: testCase.title,
                loadTime: 0,
                generationTime: 0,
                totalTime: totalTime,
                outputCharacterCount: 0,
                didFallback: true,
                errorMessage: (error as? LocalizedError)?.errorDescription ?? "Benchmark 运行失败。",
                notes: "运行失败，需检查模型文件、framework 或设备资源。",
                outputPreview: "未生成"
            )
        }
    }

    private func resetRefiningState() {
        refinedText = "尚未润色"
        refineEngine = "未运行"
        refineWasRefined = false
        refineSafetyNotice = "未记录"
        refineTime = nil
        refineErrorMessage = nil
        didFallbackToTemplate = false
        safetyCheckSummary = "未运行"
        matchedRiskTerms = "无"
    }

    private func formatDuration(_ duration: TimeInterval?) -> String {
        guard let duration else {
            return "未记录"
        }

        return String(format: "%.3f 秒", duration)
    }

    private func benchmarkResultView(_ result: LocalModelBenchmarkResult) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(result.testName)
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)

            infoRow(title: "loadTime", value: formatDuration(result.loadTime))
            infoRow(title: "generationTime", value: formatDuration(result.generationTime))
            infoRow(title: "totalTime", value: formatDuration(result.totalTime))
            infoRow(title: "didFallback", value: result.didFallback ? "true" : "false")
            infoRow(title: "输出字数", value: "\(result.outputCharacterCount)")
            infoRow(title: "output preview", value: result.outputPreview)
            infoRow(title: "notes", value: result.notes)

            if let errorMessage = result.errorMessage {
                infoRow(title: "errorMessage", value: errorMessage)
            }
        }
        .padding(.top, AppTheme.Spacing.sm)
    }

    private var deviceName: String {
        UIDevice.current.name
    }

    private var systemVersion: String {
        "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    }

    private var selectedModelFileName: String {
        currentModelInfo().fileName
    }

    private var selectedModelFileSizeDescription: String {
        guard let fileSize = currentModelInfo().fileSize else {
            return "未知"
        }

        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    private func currentModelInfo() -> (fileName: String, fileSize: UInt64?) {
        guard let path = config.existingModelPath() else {
            return (config.expectedModelFileName, nil)
        }

        let attributes = try? FileManager.default.attributesOfItem(atPath: path)
        return ((path as NSString).lastPathComponent, attributes?[.size] as? UInt64)
    }

    private func fileSizeDescription(at url: URL) -> String {
        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path)
        guard let size = attributes?[.size] as? UInt64 else {
            return "未知"
        }

        return ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
    }

    private func benchmarkSummaryText() -> String {
        var lines = [
            "DestinyScope V1.2 Local Model Benchmark",
            "Device: \(deviceName)",
            "System: \(systemVersion)",
            "Model: \(selectedModelFileName)",
            "Model Size: \(selectedModelFileSizeDescription)",
            "Results:"
        ]

        for result in benchmarkResults.reversed() {
            lines.append(
                "- \(result.testName): load=\(formatDuration(result.loadTime)), generate=\(formatDuration(result.generationTime)), total=\(formatDuration(result.totalTime)), fallback=\(result.didFallback), chars=\(result.outputCharacterCount), error=\(result.errorMessage ?? "none")"
            )
        }

        return lines.joined(separator: "\n")
    }
}
#endif
