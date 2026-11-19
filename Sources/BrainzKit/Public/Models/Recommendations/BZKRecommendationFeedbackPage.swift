//
//  BZKRecommendationFeedbackPage.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A page of a user's ratings of recommended recordings.
public struct BZKRecommendationFeedbackPage: Sendable, Hashable, Decodable {
    /// The ratings on this page, newest first.
    public let feedback: [BZKRecommendationFeedback]
    /// The offset of this page.
    public let offset: Int
    /// The total number of ratings matching the request.
    public let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case feedback
        case offset
        case totalCount = "total_count"
    }
}
