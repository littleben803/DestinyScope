//
//  AboutView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("DestinyScope")
                    .font(.title)
                    .fontWeight(.semibold)

                Text("本应用基于本地传统命理数据生成结果，出生信息仅在设备端处理。")
                    .font(.body)

                Text("内容仅供娱乐、自我探索和传统文化学习参考。")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("关于")
    }
}
