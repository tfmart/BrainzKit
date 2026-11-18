//
//  BZKRecordingStatistic.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A recording ranked by listen count.
public struct BZKRecordingStatistic: BZKStatisticsEntity, Hashable {
    /// The track name.
    public let trackName: String
    /// The MusicBrainz recording ID, if known.
    public let recordingMBID: String?
    /// The credited artist name.
    public let artistName: String
    /// The MusicBrainz artist IDs, if known.
    public let artistMBIDs: [String]?
    /// The release name, if known.
    public let releaseName: String?
    /// The MusicBrainz release ID, if known.
    public let releaseMBID: String?
    /// The number of listens.
    public let listenCount: Int
    let caaID: Int?
    let caaReleaseMBID: String?

    /// The recording's cover art, if available.
    public var coverArt: BZKCoverArt? {
        BZKCoverArt(releaseMBID: caaReleaseMBID, id: caaID)
    }

    /// The endpoint name for this entity.
    public static let endpoint = "recordings"
    /// The JSON key holding the list of entities.
    public static let itemsKey = "recordings"
    /// The JSON key holding the total number of entities.
    public static let totalCountKey = "total_recording_count"

    enum CodingKeys: String, CodingKey {
        case trackName = "track_name"
        case recordingMBID = "recording_mbid"
        case artistName = "artist_name"
        case artistMBIDs = "artist_mbids"
        case releaseName = "release_name"
        case releaseMBID = "release_mbid"
        case listenCount = "listen_count"
        case caaID = "caa_id"
        case caaReleaseMBID = "caa_release_mbid"
    }
}
