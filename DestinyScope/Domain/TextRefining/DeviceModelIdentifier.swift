//
//  DeviceModelIdentifier.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import Darwin
import Foundation

enum DeviceModelIdentifier {
    static var isRunningOnSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    static func currentIdentifier() -> String {
        #if targetEnvironment(simulator)
        if let simulatorIdentifier = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"],
           !simulatorIdentifier.isEmpty {
            return simulatorIdentifier
        }
        return "simulator"
        #else
        var systemInfo = utsname()
        uname(&systemInfo)

        return Mirror(reflecting: systemInfo.machine).children.reduce(into: "") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return
            }
            identifier.append(String(UnicodeScalar(UInt8(value))))
        }
        #endif
    }

    static func isSimulatorIdentifier(_ identifier: String) -> Bool {
        identifier == "simulator" || ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] == identifier
    }
}
