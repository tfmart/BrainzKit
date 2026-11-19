//
//  BZKRecommendedRecording.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A recording ListenBrainz recommends to a user based on what similar listeners play.
public struct BZKRecommendedRecording: Sendable, Hashable, Decodable {
    /// The MusicBrainz recording ID.
    public let recordingMBID: String
    /// How strongly the recording is recommended. Higher is stronger.
    public let score: Double
    /// When the user last listened to the recording, if they have.
    public let latestListenedAt: Date?

    enum CodingKeys: String, CodingKey {
        case recordingMBID = "recording_mbid"
        case score
        case latestListenedAt = "latest_listened_at"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recordingMBID = try container.decode(String.self, forKey: .recordingMBID)
        score = try container.decode(Double.self, forKey: .score)
        latestListenedAt = BZKISODate.parse(try container.decodeIfPresent(String.self, forKey: .latestListenedAt))
    }
}
