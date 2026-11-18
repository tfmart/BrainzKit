//
//  BZKTrackMetadata.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The track details of a listen.
public struct BZKTrackMetadata: Sendable, Hashable, Decodable {
    /// The artist name as submitted.
    public let artistName: String
    /// The track name as submitted.
    public let trackName: String
    /// The release name as submitted.
    public let releaseName: String?
    /// Extra details the submitting client sent.
    public let additionalInfo: BZKAdditionalInfo?
    /// The MusicBrainz data ListenBrainz linked to the listen, if it found a match.
    public let mbidMapping: BZKMBIDMapping?

    enum CodingKeys: String, CodingKey {
        case artistName = "artist_name"
        case trackName = "track_name"
        case releaseName = "release_name"
        case additionalInfo = "additional_info"
        case mbidMapping = "mbid_mapping"
    }
}
