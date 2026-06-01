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
            "当前正式功能",
            "DestinyScope 当前正式功能以本地计算和本地模板为基础。App 不创建账号，不需要登录，不接服务端，不接在线 AI，不包含付费订阅，也不接入广告追踪或分析 SDK。"
        ),
        (
            "出生信息处理",
            "你输入的出生日期和出生时辰仅用于设备端本地传统命理计算。当前版本不上传出生信息，也不会上传命理结果。"
        ),
        (
            "本地历史记录",
            "历史记录仅保存在本地设备，用于在 App 内查看过去生成的轻量结果。当前版本不上传历史记录，也不进行云同步。"
        ),
        (
            "系统权限",
            "当前版本不使用定位、相机、相册、通讯录、麦克风等敏感系统权限，也不会主动请求这些权限。"
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
            "模型下载",
            "当前版本不提供正式模型下载功能。如果未来支持模型下载，隐私政策会补充网络请求、模型文件大小、存储位置、删除方式和校验机制等说明。"
        ),
        (
            "本地资源",
            "本地知识库和命理数据来自 App Bundle 内置资源，包括本地 CSV、JSON 等文件。应用在设备端读取这些资源完成展示和计算。"
        ),
        (
            "未来版本",
            "如果未来版本加入联网、账号、订阅、数据同步或其他需要处理用户数据的能力，隐私说明会在对应版本中更新。"
        )
    ]

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    AppCard {
                        Text("隐私政策")
                            .font(AppTheme.Typography.pageTitle)
                            .foregroundColor(AppTheme.Colors.primaryText)

                        Text("适用于 DestinyScope 当前版本。正式功能以完全 Native、本地处理和无服务端为基础；本地模型润色仍属于受控实验路径。")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }

                    ForEach(sections, id: \.title) { section in
                        AppCard {
                            AppSectionHeader(title: section.title)
                            Text(section.body)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("隐私政策")
    }
}
