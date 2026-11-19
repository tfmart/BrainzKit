//
//  BZKArtistTopRecording.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// One of an artist's most listened recordings across ListenBrainz.
public struct BZKArtistTopRecording: Sendable, Hashable, Decodable {
    /// The recording name.
    public let recordingName: String
    /// The MusicBrainz recording ID.
    public let recordingMBID: String
    /// The credited artist name.
    public let artistName: String
    /// The MusicBrainz artist IDs.
    public let artistMBIDs: [String]
    /// The individual artists in the credit, if known.
    public let artists: [BZKArtistCredit]?
    /// The release name, if known.
    public let releaseName: String?
    /// The MusicBrainz release ID, if known.
    public let releaseMBID: String?
    /// The recording length in seconds, if known.
    public let duration: TimeInterval?
    /// The total number of listens.
    public let listenCount: Int
    /// The number of users who listened.
    public let userCount: Int
    /// The release's cover art, if available.
    public let coverArt: BZKCoverArt?

    enum CodingKeys: String, CodingKey {
        case recordingName = "recording_name"
        case recordingMBID = "recording_mbid"
        case artistName = "artist_name"
        case artistMBIDs = "artist_mbids"
        case artists
        case releaseName = "release_name"
        case releaseMBID = "release_mbid"
        case length
        case listenCount = "total_listen_count"
        case userCount = "total_user_count"
        case caaID = "caa_id"
        case caaReleaseMBID = "caa_release_mbid"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recordingName = try container.decode(String.self, forKey: .recordingName)
        recordingMBID = try container.decode(String.self, forKey: .recordingMBID)
        artistName = try container.decode(String.self, forKey: .artistName)
        artistMBIDs = try container.decodeIfPresent([String].self, forKey: .artistMBIDs) ?? []
        artists = try container.decodeIfPresent([BZKArtistCredit].self, forKey: .artists)
        releaseName = try container.decodeIfPresent(String.self, forKey: .releaseName)
        releaseMBID = try container.decodeIfPresent(String.self, forKey: .releaseMBID)
        duration = try container.decodeIfPresent(Double.self, forKey: .length).map { $0 / 1000 }
        listenCount = try container.decode(Int.self, forKey: .listenCount)
        userCount = try container.decode(Int.self, forKey: .userCount)
        coverArt = BZKCoverArt(
            releaseMBID: try container.decodeIfPresent(String.self, forKey: .caaReleaseMBID),
            id: try container.decodeIfPresent(Int.self, forKey: .caaID)
        )
    }
}
