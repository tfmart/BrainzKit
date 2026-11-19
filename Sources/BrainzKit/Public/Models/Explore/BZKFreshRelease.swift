//
//  BZKFreshRelease.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A recent or upcoming release from MusicBrainz.
public struct BZKFreshRelease: Sendable, Hashable, Decodable {
    /// The release name.
    public let releaseName: String
    /// The MusicBrainz release ID.
    public let releaseMBID: String
    /// The MusicBrainz release group ID, if known.
    public let releaseGroupMBID: String?
    /// The credited artist name.
    public let artistName: String
    /// The MusicBrainz artist IDs.
    public let artistMBIDs: [String]
    /// The release date as an ISO 8601 date string.
    public let releaseDate: String
    /// The primary type, such as "Album", "Single", or "EP", if known.
    public let type: String?
    /// The number of listens on ListenBrainz, if known.
    public let listenCount: Int?
    /// The release's tags.
    public let tags: [String]
    /// The release's cover art, if available.
    public let coverArt: BZKCoverArt?
    /// How well the release matches the user's listening, present in a user's personal fresh releases. Higher is a better match.
    public let confidence: Int?

    enum CodingKeys: String, CodingKey {
        case releaseName = "release_name"
        case releaseMBID = "release_mbid"
        case releaseGroupMBID = "release_group_mbid"
        case artistName = "artist_credit_name"
        case artistMBIDs = "artist_mbids"
        case releaseDate = "release_date"
        case type = "release_group_primary_type"
        case listenCount = "listen_count"
        case tags = "release_tags"
        case caaID = "caa_id"
        case caaReleaseMBID = "caa_release_mbid"
        case confidence
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        releaseName = try container.decode(String.self, forKey: .releaseName)
        releaseMBID = try container.decode(String.self, forKey: .releaseMBID)
        releaseGroupMBID = try container.decodeIfPresent(String.self, forKey: .releaseGroupMBID)
        artistName = try container.decode(String.self, forKey: .artistName)
        artistMBIDs = try container.decodeIfPresent([String].self, forKey: .artistMBIDs) ?? []
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        listenCount = try container.decodeIfPresent(Int.self, forKey: .listenCount)
        tags = (try? container.decodeIfPresent([String].self, forKey: .tags)) ?? []
        confidence = try container.decodeIfPresent(Int.self, forKey: .confidence)
        coverArt = BZKCoverArt(
            releaseMBID: try container.decodeIfPresent(String.self, forKey: .caaReleaseMBID),
            id: try container.decodeIfPresent(Int.self, forKey: .caaID)
        )
    }
}
