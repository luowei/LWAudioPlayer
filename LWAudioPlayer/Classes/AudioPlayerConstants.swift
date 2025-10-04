//
// AudioPlayerConstants.swift
// LWAudioPlayer
//
// Created by Swift Migration on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Debug Logging

#if DEBUG
func AudioLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    print("[\(file.components(separatedBy: "/").last ?? "")] \(function):\(line) - \(message)")
}
#else
func AudioLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {}
#endif

// MARK: - UserDefaults Keys

public struct AudioPlayerKeys {
    public static let isSingleLoop = "Key_isSingleLoop"
    public static let speedRate = "Key_AudioPlayer_SpeedRate"
    public static let eventSubtype = "Key_EventSubtype"
}

// MARK: - Screen Dimensions

public struct ScreenDimensions {
    public static var width: CGFloat {
        UIScreen.main.bounds.width
    }

    public static var height: CGFloat {
        UIScreen.main.bounds.height
    }
}

// MARK: - System Version Helper

public struct SystemVersion {
    public static func isGreaterThanOrEqualTo(_ version: String) -> Bool {
        let currentVersion = UIDevice.current.systemVersion
        return currentVersion.compare(version, options: .numeric) != .orderedAscending
    }
}

// MARK: - Bundle Helper

public struct AudioPlayerBundle {
    public static func bundle(for classType: AnyClass) -> Bundle {
        if let path = Bundle(for: classType).path(forResource: "LWAudioPlayer", ofType: "bundle"),
           let bundle = Bundle(path: path) {
            return bundle
        }
        if let path = Bundle.main.path(forResource: "LWAudioPlayer", ofType: "bundle"),
           let bundle = Bundle(path: path) {
            return bundle
        }
        return Bundle.main
    }

    public static func image(named: String, for classType: AnyClass) -> UIImage? {
        let bundle = AudioPlayerBundle.bundle(for: classType)
        return UIImage(named: named, in: bundle, compatibleWith: nil)
    }
}
