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
            "DestinyScope V1 不创建账号，也不需要登录。应用内没有用户注册、身份认证、云同步或个人资料系统。"
        ),
        (
            "出生信息处理",
            "你输入的出生日期和出生时辰仅用于设备本地的传统命理计算。V1 不会上传出生信息，也不会把这些信息发送到服务端或第三方服务。"
        ),
        (
            "服务端与在线 AI",
            "DestinyScope V1 不接服务端，不接在线 AI，也不使用真实本地 LLM 推理。命理结果来自 App 内置数据、本地计算规则和本地模板。"
        ),
        (
            "系统权限",
            "V1 不使用定位、相机、相册、通讯录、麦克风等系统权限，也不会主动请求这些权限。"
        ),
        (
            "广告与追踪",
            "V1 不包含广告追踪，不接入广告 SDK、分析 SDK 或跨应用追踪能力。"
        ),
        (
            "本地资源",
            "本地知识库和命理数据来自 App Bundle 内置资源，包括本地 CSV、JSON 等文件。应用在设备端读取这些资源完成展示和计算。"
        ),
        (
            "未来版本",
            "如果未来版本加入联网、AI、账号、订阅、数据同步或其他需要处理用户数据的能力，隐私说明会在对应版本中更新。"
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

                        Text("适用于 DestinyScope V1。当前版本以完全 Native、本地处理和无服务端为基础。")
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
