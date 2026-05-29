//
//  DeviceTierService.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import Foundation

struct DeviceTierService {
    func currentDeviceTier() -> DeviceTier {
        tier(for: DeviceModelIdentifier.currentIdentifier())
    }

    func tier(for identifier: String) -> DeviceTier {
        if DeviceModelIdentifier.isSimulatorIdentifier(identifier) {
            return .unknown
        }

        if identifier == "iPhone13,1" {
            return .tierC
        }

        if let iPhoneMajor = iPhoneMajorVersion(from: identifier) {
            switch iPhoneMajor {
            case ...13:
                return .tierC
            case 14, 15:
                return .tierB
            case 16:
                return isKnownA17ProIdentifier(identifier) ? .tierA : .tierB
            case 17...:
                return .tierA
            default:
                return .unknown
            }
        }

        // TODO: Add iPad and future iPhone mappings after collecting more benchmark data.
        return .unknown
    }

    private func iPhoneMajorVersion(from identifier: String) -> Int? {
        guard identifier.hasPrefix("iPhone") else {
            return nil
        }

        let value = identifier.dropFirst("iPhone".count).split(separator: ",").first
        return value.flatMap { Int($0) }
    }

    private func isKnownA17ProIdentifier(_ identifier: String) -> Bool {
        // iPhone 15 Pro / iPhone 15 Pro Max.
        identifier == "iPhone16,1" || identifier == "iPhone16,2"
    }
}
