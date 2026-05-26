//
//  SettingsView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            NavigationLink("关于 DestinyScope") {
                AboutView()
            }
        }
        .navigationTitle("关于")
    }
}
