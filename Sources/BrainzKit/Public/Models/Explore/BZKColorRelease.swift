//
//  BZKColorRelease.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A release whose cover art matches a color.
public struct BZKColorRelease: Sendable, Hashable, Decodable {
    /// The release name.
    public let releaseName: String
    /// The MusicBrainz release ID.
    public let releaseMBID: String
    /// The credited artist name.
    public let artistName: String
    /// The cover art's dominant color as red, green, and blue values from 0 to 255.
    public let color: [Int]
    /// The release's cover art, if available.
    public let coverArt: BZKCoverArt?
    /// The release's tracks.
    public let recordings: [BZKTrackMetadata]

    enum CodingKeys: String, CodingKey {
        case releaseName = "release_name"
        case releaseMBID = "release_mbid"
        case artistName = "artist_name"
        case color
        case caaID = "caa_id"
        case recordings
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        releaseName = try container.decode(String.self, forKey: .releaseName)
        releaseMBID = try container.decode(String.self, forKey: .releaseMBID)
        artistName = try container.decode(String.self, forKey: .artistName)
        color = try container.decodeIfPresent([Int].self, forKey: .color) ?? []
        coverArt = BZKCoverArt(releaseMBID: releaseMBID, id: try container.decodeIfPresent(Int.self, forKey: .caaID))
        recordings = ((try? container.decodeIfPresent([BZKColorReleaseRecording].self, forKey: .recordings)) ?? nil)?.map(\.track) ?? []
    }
}
