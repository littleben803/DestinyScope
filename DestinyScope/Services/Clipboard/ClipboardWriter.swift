//
//  ClipboardWriter.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import UIKit

struct ClipboardWriter {
    func copy(_ text: String) {
        UIPasteboard.general.string = text
    }
}
