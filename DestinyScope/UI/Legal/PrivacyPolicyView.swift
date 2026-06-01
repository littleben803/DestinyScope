//
//  PrivacyPolicyView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct PrivacyPolicyView: View {
    private let sections: [(title: String, body: String)] = [
        (
            "账号与登录",
            "DestinyScope 当前版本不创建账号，也不需要登录。使用首页查询、结果页、知识库和历史记录功能时，不需要提供姓名、手机号、邮箱或其他账号信息。"
        ),
        (
            "出生信息处理",
            "你输入的出生日期和出生时辰仅用于设备端本地传统命理计算。当前版本不上传出生信息，也不会上传命理结果。"
        ),
        (
            "本地历史记录",
            "历史记录仅保存在本地设备，用于在 App 内查看过去生成的轻量结果。当前版本不上传历史记录，也不进行云同步。你可以在历史记录页面删除单条记录或清空全部记录。"
        ),
        (
            "本地模型实验",
            "本地模型润色实验仅在 Debug/TestFlight 或受控实验开关开启时可用，默认关闭，并需要用户手动开启。该功能只在设备端对已有模板文本做表达润色，不生成新的命理结论，不替代称骨计算、诗文匹配、命格洞察或模板问答。"
        ),
        (
            "本地模型实验数据",
            "本地模型实验不上传模型输入，不上传模型输出，不上传出生信息，不上传命理结果，也不上传历史记录。润色结果默认不保存到历史记录。失败、超时、低电量、过热或安全检查失败时，会回退到本地模板文本。"
        ),
        (
            "网络与服务端",
            "当前版本不接服务端，不接在线 AI，也不提供正式模型下载功能。如果未来支持联网能力或模型下载，隐私政策会补充网络请求、模型文件大小、存储位置、删除方式和校验机制等说明。"
        ),
        (
            "系统权限",
            "当前版本不使用定位、相机、相册、通讯录、麦克风等敏感系统权限，也不会主动请求这些权限。"
        ),
        (
            "广告、分析与追踪",
            "当前版本不接入广告追踪，不接入分析 SDK，不包含付费订阅，也不使用第三方在线模型服务处理用户输入。"
        ),
        (
            "本地资源",
            "本地知识库和命理数据来自 App Bundle 内置资源，包括本地 CSV、JSON 等文件。应用在设备端读取这些资源完成展示和计算。"
        ),
        (
            "未来版本",
            "如果未来版本加入联网、账号、订阅、数据同步或其他需要处理用户数据的能力，隐私说明会在对应版本中更新。"
        ),
        (
            "联系方式",
            "如对本隐私政策有任何问题，请联系：littleben803@gmail.com"
        )
    ]

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    LegalSummaryCard(
                        title: "隐私政策",
                        bodyText: "适用于 DestinyScope 当前版本。正式功能以 Native、本地处理和无服务端为基础；本地模型润色仍属于受控实验路径。",
                        highlights: [
                            "当前版本不创建账号、不需要登录。",
                            "出生信息、命理结果和历史记录不上传。",
                            "本地模型润色实验默认关闭，只在设备端处理已有模板文本。"
                        ]
                    )

                    ForEach(sections, id: \.title) { section in
                        LegalSectionCard(title: section.title, bodyText: section.body)
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("隐私政策")
    }
}
