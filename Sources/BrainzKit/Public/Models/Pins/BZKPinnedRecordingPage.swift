//
//  BZKPinnedRecordingPage.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A page of a user's pinned recordings, newest first.
public struct BZKPinnedRecordingPage: Sendable, Hashable, Decodable {
    /// The pins on this page.
    public let pins: [BZKPinnedRecording]
    /// The offset of this page.
    public let offset: Int
    /// The total number of pins the user has made.
    public let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case pins = "pinned_recordings"
        case offset
        case totalCount = "total_count"
    }
}
