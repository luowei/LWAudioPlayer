//
// AudioItem.swift
// LWAudioPlayer
//
// Created by Swift Migration on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import Foundation

/// Represents an audio item in the playlist
public class AudioItem: NSObject, Codable {

    // MARK: - Properties

    /// The name of the audio item
    public var name: String

    /// The type of the item (e.g., "audio", "folder")
    public var type: String

    /// The file path to the audio item
    public var itemPath: String

    /// Nested list of items (for folders)
    public var itemList: [AudioItem]?

    /// Artist name or information
    public var artist: String?

    /// Album title
    public var albumTitle: String?

    // MARK: - Initialization

    public init(name: String, type: String, itemPath: String, itemList: [AudioItem]? = nil) {
        self.name = name
        self.type = type
        self.itemPath = itemPath
        self.itemList = itemList
        super.init()
    }

    // MARK: - UTI (Uniform Type Identifier)

    /// Returns the UTI (Uniform Type Identifier) for the item based on its extension
    public func uti() -> String {
        guard let ext = name.components(separatedBy: ".").last?.lowercased() else {
            return "public.data"
        }

        if type == AudioItemType.folder {
            return "public.folder"
        }

        // Archive formats
        if ext == "zip" { return "com.pkware.zip-archive" }

        // Image formats
        if ext == "png" { return "public.png" }
        if ext == "jpg" || ext == "jpeg" { return "public.jpeg" }
        if ext == "jp2" { return "public.jpeg-2000" }
        if ext == "gif" { return "com.compuserve.gif" }
        if ext == "ai" { return "com.adobe.illustrator.ai-image" }
        if ext == "bmp" { return "com.microsoft.bmp" }
        if ext == "tif" || ext == "tiff" { return "public.tiff" }

        // Video formats
        if ext == "avi" || ext == "vfw" { return "public.avi" }
        if ext == "mpg" || ext == "mpeg" { return "public.mpeg" }
        if ext == "mp4" || ext == "mpg4" { return "public.mpeg-4" }
        if ext == "3gp" || ext == "3gpp" { return "public.3gpp" }
        if ext == "3g2" || ext == "3gp2" { return "public.3gpp2" }
        if ext == "wmv" { return "com.microsoft.windows-media-wmv" }
        if ext == "mov" || ext == "qt" { return "com.apple.quicktime-movie" }

        // Audio formats
        if ext == "mp3" || ext == "mpg3" { return "public.mp3" }
        if ext == "m4a" { return "public.mpeg-4-audio" }
        if ext == "wav" { return "com.microsoft.waveform-audio" }
        if ext == "wma" { return "com.microsoft.windows-media-wma" }
        if ext == "aif" || ext == "aifc" { return "public.aifc-audio" }
        if ext == "aiff" { return "public.aiff-audio" }

        // Document formats
        if ext == "html" || ext == "htm" { return "public.html" }
        if ext == "xml" { return "public.xml" }
        if ext == "rtfd" { return "com.apple.rtfd" }
        if ext == "txt" { return "public.plain-text" }
        if ext == "rtf" { return "public.rtf" }
        if ext == "pdf" { return "com.adobe.pdf" }
        if ext == "doc" { return "com.microsoft.word.doc" }
        if ext == "xls" { return "com.microsoft.excel.xls" }
        if ext == "ppt" { return "com.microsoft.powerpoint.ppt" }

        // Source code formats
        let sourceCodeExtensions = ["c", "m", "cpp", "mm", "h", "hpp", "java",
                                   "s", "r", "js", "json", "sh", "pl", "py", "rb", "php"]
        if sourceCodeExtensions.contains(ext) {
            return "public.source-code"
        }

        return "public.data"
    }
}

// MARK: - Audio Item Types

public struct AudioItemType {
    public static let folder = "folder"
    public static let file = "file"
    public static let document = "document"
    public static let image = "image"
    public static let video = "video"
    public static let audio = "audio"
}
