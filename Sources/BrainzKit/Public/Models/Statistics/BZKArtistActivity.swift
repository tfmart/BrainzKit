//
//  BZKArtistActivity.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// An artist's listens broken down by album.
public struct BZKArtistActivity: Sendable, Hashable, Decodable {
    /// The artist name.
    public let artistName: String
    /// The MusicBrainz artist ID, if known.
    public let artistMBID: String?
    /// The artist's total listens.
    public let listenCount: Int
    /// The artist's albums, most listened first.
    public let albums: [BZKArtistActivityAlbum]

    enum CodingKeys: String, CodingKey {
        case artistName = "artist_name"
        case name
        case artistMBID = "artist_mbid"
        case listenCount = "listen_count"
        case albums
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        artistName = try container.decodeIfPresent(String.self, forKey: .artistName) ?? container.decode(String.self, forKey: .name)
        artistMBID = try container.decodeIfPresent(String.self, forKey: .artistMBID)
        listenCount = try container.decode(Int.self, forKey: .listenCount)
        albums = (try container.decodeIfPresent([BZKArtistActivityAlbum].self, forKey: .albums) ?? [])
            .sorted { $0.listenCount > $1.listenCount }
    }
}
