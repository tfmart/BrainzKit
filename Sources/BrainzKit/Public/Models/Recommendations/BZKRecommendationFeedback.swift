//
//  BZKRecommendationFeedback.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A user's rating of a recommended recording.
public struct BZKRecommendationFeedback: Sendable, Hashable, Decodable {
    /// The MusicBrainz recording ID.
    public let recordingMBID: String
    /// The rating.
    public let rating: BZKRecommendationRating
    /// When the rating was given, if known.
    public let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case recordingMBID = "recording_mbid"
        case rating
        case createdAt = "created"
    }
}
