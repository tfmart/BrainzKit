//
//  BZKArtistStatistic.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// An artist ranked by listen count.
public struct BZKArtistStatistic: BZKStatisticsEntity, Hashable {
    /// The artist name.
    public let artistName: String
    /// The MusicBrainz artist ID, if known.
    public let artistMBID: String?
    /// The number of listens.
    public let listenCount: Int

    /// The endpoint name for this entity.
    public static let endpoint = "artists"
    /// The JSON key holding the list of entities.
    public static let itemsKey = "artists"
    /// The JSON key holding the total number of entities.
    public static let totalCountKey = "total_artist_count"

    enum CodingKeys: String, CodingKey {
        case artistName = "artist_name"
        case artistMBID = "artist_mbid"
        case listenCount = "listen_count"
    }
}
