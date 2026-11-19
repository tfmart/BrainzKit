//
//  BZKArtistActivityAlbum.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// One of an artist's albums and how often it was played.
public struct BZKArtistActivityAlbum: Sendable, Hashable, Decodable {
    /// The release group name.
    public let name: String
    /// The MusicBrainz release group ID, if known.
    public let releaseGroupMBID: String?
    /// The number of listens.
    public let listenCount: Int

    enum CodingKeys: String, CodingKey {
        case name
        case releaseGroupMBID = "release_group_mbid"
        case listenCount = "listen_count"
    }
}
