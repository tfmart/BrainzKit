//
//  BZKReleaseGroupMetadata.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// MusicBrainz details about a release group, such as an album or single.
public struct BZKReleaseGroupMetadata: Sendable, Hashable, Decodable {
    /// The release group name.
    public let name: String
    /// The primary type, such as "Album", "Single", or "EP", if known.
    public let type: String?
    /// The first release date as an ISO 8601 date string, which may contain only a year or a year and month.
    public let releaseDate: String?
    /// The credited artist name, if known.
    public let artistName: String?
    /// The individual artists in the credit.
    public let artists: [BZKArtistMetadata]
    /// The release group's cover art, if available.
    public let coverArt: BZKCoverArt?
    /// The release group's tags, including genres, most applied first.
    public let tags: [BZKTag]
    /// The tags of the release group's artists, most applied first.
    public let artistTags: [BZKTag]

    enum CodingKeys: String, CodingKey {
        case releaseGroup = "release_group"
        case artist
        case tag
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let summary = try container.decode(BZKReleaseGroupSummary.self, forKey: .releaseGroup)
        name = summary.name
        type = summary.type
        releaseDate = summary.date
        coverArt = BZKCoverArt(releaseMBID: summary.caaReleaseMBID, id: summary.caaID)
        let credit = try? container.decodeIfPresent(BZKMetadataArtistCredit.self, forKey: .artist)
        artistName = credit?.name
        artists = credit?.artists ?? []
        let tagGroups = try? container.decodeIfPresent(BZKMetadataTags.self, forKey: .tag)
        tags = tagGroups?.releaseGroup ?? []
        artistTags = tagGroups?.artist ?? []
    }
}
