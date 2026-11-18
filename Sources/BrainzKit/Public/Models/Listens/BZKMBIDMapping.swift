//
//  BZKMBIDMapping.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The MusicBrainz data ListenBrainz linked to a listen.
public struct BZKMBIDMapping: Sendable, Hashable, Decodable {
    /// The MusicBrainz recording ID.
    public let recordingMBID: String?
    /// The recording name as it appears on MusicBrainz.
    public let recordingName: String?
    /// The MusicBrainz release ID.
    public let releaseMBID: String?
    /// The MusicBrainz release group ID.
    public let releaseGroupMBID: String?
    /// The MusicBrainz artist IDs.
    public let artistMBIDs: [String]?
    /// The recording's artist credit.
    public let artists: [BZKArtistCredit]?
    let caaID: Int?
    let caaReleaseMBID: String?

    /// The recording's cover art, if available.
    public var coverArt: BZKCoverArt? {
        BZKCoverArt(releaseMBID: caaReleaseMBID, id: caaID)
    }

    enum CodingKeys: String, CodingKey {
        case recordingMBID = "recording_mbid"
        case recordingName = "recording_name"
        case releaseMBID = "release_mbid"
        case releaseGroupMBID = "release_group_mbid"
        case artistMBIDs = "artist_mbids"
        case artists
        case caaID = "caa_id"
        case caaReleaseMBID = "caa_release_mbid"
    }
}
