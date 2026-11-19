//
//  BZKArtistTopReleaseGroup.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// One of an artist's most listened albums, singles, or other release groups across ListenBrainz.
public struct BZKArtistTopReleaseGroup: Sendable, Hashable, Decodable {
    /// The MusicBrainz release group ID.
    public let releaseGroupMBID: String
    /// The release group name.
    public let name: String
    /// The primary type, such as "Album", "Single", or "EP", if known.
    public let type: String?
    /// The first release date as an ISO 8601 date string, which may contain only a year or a year and month.
    public let releaseDate: String?
    /// The credited artist name, if known.
    public let artistName: String?
    /// The total number of listens.
    public let listenCount: Int
    /// The number of users who listened.
    public let userCount: Int
    /// The release group's cover art, if available.
    public let coverArt: BZKCoverArt?

    enum CodingKeys: String, CodingKey {
        case releaseGroupMBID = "release_group_mbid"
        case releaseGroup = "release_group"
        case artist
        case listenCount = "total_listen_count"
        case userCount = "total_user_count"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        releaseGroupMBID = try container.decode(String.self, forKey: .releaseGroupMBID)
        let summary = try container.decode(BZKReleaseGroupSummary.self, forKey: .releaseGroup)
        name = summary.name
        type = summary.type
        releaseDate = summary.date
        artistName = try container.decodeIfPresent(BZKArtistCreditSummary.self, forKey: .artist)?.name
        listenCount = try container.decode(Int.self, forKey: .listenCount)
        userCount = try container.decode(Int.self, forKey: .userCount)
        coverArt = BZKCoverArt(releaseMBID: summary.caaReleaseMBID, id: summary.caaID)
    }
}
