//
//  BZKGenreActivity.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The number of listens to one genre in one hour of the day.
public struct BZKGenreActivity: Sendable, Hashable, Decodable {
    /// The genre name.
    public let genre: String
    /// The hour of the day in UTC, from 0 to 23.
    public let hour: Int
    /// The number of listens.
    public let listenCount: Int

    enum CodingKeys: String, CodingKey {
        case genre
        case hour
        case listenCount = "listen_count"
    }
}
