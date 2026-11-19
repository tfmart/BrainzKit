//
//  BZKGenreShare.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// How much of a user's listening went to one genre.
public struct BZKGenreShare: Sendable, Hashable, Decodable {
    /// The genre name.
    public let genre: String
    /// The number of listens tagged with the genre.
    public let listenCount: Int
    /// The genre's share of the user's listens, from 0 to 100.
    public let percentage: Double

    enum CodingKeys: String, CodingKey {
        case genre
        case listenCount = "genre_count"
        case percentage = "genre_count_percent"
    }
}
