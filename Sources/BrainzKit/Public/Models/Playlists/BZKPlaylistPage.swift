//
//  BZKPlaylistPage.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A page of playlists.
public struct BZKPlaylistPage: Sendable, Hashable, Decodable {
    /// The playlists on this page, without their tracks.
    public let playlists: [BZKPlaylist]
    /// The offset of this page.
    public let offset: Int
    /// The total number of playlists matching the request.
    public let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case playlists
        case offset
        case totalCount = "playlist_count"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        playlists = try container.decode([BZKPlaylistEnvelope].self, forKey: .playlists).map(\.playlist)
        offset = try container.decode(Int.self, forKey: .offset)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
    }
}
