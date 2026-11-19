//
//  BZKRecommendationRating.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A user's rating of a recommended recording.
public enum BZKRecommendationRating: String, Sendable, Hashable, CaseIterable, Codable {
    /// The user loves the recording.
    case love
    /// The user likes the recording.
    case like
    /// The user dislikes the recording.
    case dislike
    /// The user hates the recording.
    case hate
    /// The recording doesn't fit the user's taste, regardless of whether they like it.
    case badRecommendation = "bad_recommendation"
}
