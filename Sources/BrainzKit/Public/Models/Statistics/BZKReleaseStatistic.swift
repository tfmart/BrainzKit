//
//  BZKReleaseStatistic.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A release ranked by listen count.
public struct BZKReleaseStatistic: BZKStatisticsEntity, Hashable {
    /// The release name.
    public let releaseName: String
    /// The MusicBrainz release ID, if known.
    public let releaseMBID: String?
    /// The credited artist name.
    public let artistName: String
    /// The MusicBrainz artist IDs, if known.
    public let artistMBIDs: [String]?
    /// The number of listens.
    public let listenCount: Int
    let caaID: Int?
    let caaReleaseMBID: String?

    /// The release's cover art, if available.
    public var coverArt: BZKCoverArt? {
        BZKCoverArt(releaseMBID: caaReleaseMBID, id: caaID)
    }

    /// The endpoint name for this entity.
    public static let endpoint = "releases"
    /// The JSON key holding the list of entities.
    public static let itemsKey = "releases"
    /// The JSON key holding the total number of entities.
    public static let totalCountKey = "total_release_count"

    enum CodingKeys: String, CodingKey {
        case releaseName = "release_name"
        case releaseMBID = "release_mbid"
        case artistName = "artist_name"
        case artistMBIDs = "artist_mbids"
        case listenCount = "listen_count"
        case caaID = "caa_id"
        case caaReleaseMBID = "caa_release_mbid"
    }
}
