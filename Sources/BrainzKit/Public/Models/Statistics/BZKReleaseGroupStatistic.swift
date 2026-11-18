//
//  BZKReleaseGroupStatistic.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A release group, such as an album, ranked by listen count.
public struct BZKReleaseGroupStatistic: BZKStatisticsEntity, Hashable {
    /// The release group name.
    public let releaseGroupName: String
    /// The MusicBrainz release group ID, if known.
    public let releaseGroupMBID: String?
    /// The credited artist name.
    public let artistName: String
    /// The MusicBrainz artist IDs, if known.
    public let artistMBIDs: [String]?
    /// The number of listens.
    public let listenCount: Int
    let caaID: Int?
    let caaReleaseMBID: String?

    /// The release group's cover art, if available.
    public var coverArt: BZKCoverArt? {
        BZKCoverArt(releaseMBID: caaReleaseMBID, id: caaID)
    }

    /// The endpoint name for this entity.
    public static let endpoint = "release-groups"
    /// The JSON key holding the list of entities.
    public static let itemsKey = "release_groups"
    /// The JSON key holding the total number of entities.
    public static let totalCountKey = "total_release_group_count"

    enum CodingKeys: String, CodingKey {
        case releaseGroupName = "release_group_name"
        case releaseGroupMBID = "release_group_mbid"
        case artistName = "artist_name"
        case artistMBIDs = "artist_mbids"
        case listenCount = "listen_count"
        case caaID = "caa_id"
        case caaReleaseMBID = "caa_release_mbid"
    }
}
