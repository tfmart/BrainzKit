//
//  BZKRecommendationPage.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A page of recordings recommended to a user.
public struct BZKRecommendationPage: Sendable, Hashable, Decodable {
    /// The recommended recordings, strongest first.
    public let recordings: [BZKRecommendedRecording]
    /// The offset of this page.
    public let offset: Int
    /// The total number of recommendations available.
    public let totalCount: Int
    /// When the recommendations were generated.
    public let lastUpdated: Date?

    enum CodingKeys: String, CodingKey {
        case recordings = "mbids"
        case offset
        case totalCount = "total_mbid_count"
        case lastUpdated = "last_updated"
    }
}
