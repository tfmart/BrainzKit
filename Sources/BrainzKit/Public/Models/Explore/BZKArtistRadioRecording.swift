//
//  BZKArtistRadioRecording.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A recording LB Radio picked for an artist radio.
public struct BZKArtistRadioRecording: Sendable, Hashable, Decodable {
    /// The MusicBrainz recording ID.
    public let recordingMBID: String
    /// The MusicBrainz ID of the artist the recording was picked for: the seed artist or a similar one.
    public let artistMBID: String
    /// The name of that artist.
    public let artistName: String
    /// The recording's total listens on ListenBrainz.
    public let listenCount: Int

    enum CodingKeys: String, CodingKey {
        case recordingMBID = "recording_mbid"
        case artistMBID = "similar_artist_mbid"
        case artistName = "similar_artist_name"
        case listenCount = "total_listen_count"
    }
}
