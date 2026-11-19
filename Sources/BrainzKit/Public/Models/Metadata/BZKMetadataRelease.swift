//
//  BZKMetadataRelease.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The release MusicBrainz considers canonical for a recording.
public struct BZKMetadataRelease: Sendable, Hashable, Decodable {
    /// The release name.
    public let name: String
    /// The MusicBrainz release ID.
    public let mbid: String
    /// The MusicBrainz release group ID, if known.
    public let releaseGroupMBID: String?
    /// The release year, if known.
    public let year: Int?
    /// The release's credited artist, if known.
    public let albumArtistName: String?
    /// The release's cover art, if available.
    public let coverArt: BZKCoverArt?

    enum CodingKeys: String, CodingKey {
        case name
        case mbid
        case releaseGroupMBID = "release_group_mbid"
        case year
        case albumArtistName = "album_artist_name"
        case caaID = "caa_id"
        case caaReleaseMBID = "caa_release_mbid"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        mbid = try container.decode(String.self, forKey: .mbid)
        releaseGroupMBID = try container.decodeIfPresent(String.self, forKey: .releaseGroupMBID)
        year = try container.decodeIfPresent(Int.self, forKey: .year)
        albumArtistName = try container.decodeIfPresent(String.self, forKey: .albumArtistName)
        coverArt = BZKCoverArt(
            releaseMBID: try container.decodeIfPresent(String.self, forKey: .caaReleaseMBID),
            id: try container.decodeIfPresent(Int.self, forKey: .caaID)
        )
    }
}
