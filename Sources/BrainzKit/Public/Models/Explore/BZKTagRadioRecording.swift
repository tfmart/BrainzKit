//
//  BZKTagRadioRecording.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A recording LB Radio picked for a tag radio.
public struct BZKTagRadioRecording: Sendable, Hashable, Decodable {
    /// The MusicBrainz recording ID.
    public let recordingMBID: String
    /// Where the tag was applied: "recording", "release-group", or "artist".
    public let source: String
    /// How many times the tag was applied.
    public let tagCount: Int
    /// The recording's popularity percentile, from 0 to 100.
    public let popularity: Double

    enum CodingKeys: String, CodingKey {
        case recordingMBID = "recording_mbid"
        case source
        case tagCount = "tag_count"
        case popularity = "percent"
    }
}
