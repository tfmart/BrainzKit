//
//  BZKRecordingQuery.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// An artist and track name to match to a MusicBrainz recording.
public struct BZKRecordingQuery: Sendable, Hashable, Encodable {
    /// The artist name.
    public var artist: String
    /// The track name.
    public var track: String
    /// The release name, which improves accuracy when provided.
    public var release: String?

    /// Creates a query.
    ///
    /// - Parameters:
    ///   - artist: The artist name.
    ///   - track: The track name.
    ///   - release: The release name, which improves accuracy when provided.
    public init(artist: String, track: String, release: String? = nil) {
        self.artist = artist
        self.track = track
        self.release = release
    }

    enum CodingKeys: String, CodingKey {
        case artist = "artist_name"
        case track = "recording_name"
        case release = "release_name"
    }
}
