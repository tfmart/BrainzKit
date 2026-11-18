//
//  BZKAdditionalInfo.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// Extra details the submitting client sent with a listen.
///
/// Clients send different details, so every value is optional.
public struct BZKAdditionalInfo: Sendable, Hashable, Decodable {
    /// The track's length.
    public let duration: TimeInterval?
    /// The MusicBrainz recording ID sent by the client.
    public let recordingMBID: String?
    /// The ListenBrainz recording MSID.
    public let recordingMSID: String?
    /// The MusicBrainz release ID sent by the client.
    public let releaseMBID: String?
    /// The MusicBrainz release group ID sent by the client.
    public let releaseGroupMBID: String?
    /// The MusicBrainz artist IDs sent by the client.
    public let artistMBIDs: [String]?
    /// The track's International Standard Recording Code.
    public let isrc: String?
    /// The Spotify track URL or ID.
    public let spotifyID: String?
    /// A URL where the track can be played.
    public let originURL: String?
    /// The domain of the service the music was played from.
    public let musicService: String?
    /// The name of the service the music was played from.
    public let musicServiceName: String?
    /// The name of the app that submitted the listen.
    public let submissionClient: String?
    /// The version of the app that submitted the listen.
    public let submissionClientVersion: String?
    /// The name of the player that played the track.
    public let mediaPlayer: String?
    /// Tags describing the track.
    public let tags: [String]?

    enum CodingKeys: String, CodingKey {
        case durationMs = "duration_ms"
        case duration
        case recordingMBID = "recording_mbid"
        case recordingMSID = "recording_msid"
        case releaseMBID = "release_mbid"
        case releaseGroupMBID = "release_group_mbid"
        case artistMBIDs = "artist_mbids"
        case isrc
        case spotifyID = "spotify_id"
        case originURL = "origin_url"
        case musicService = "music_service"
        case musicServiceName = "music_service_name"
        case submissionClient = "submission_client"
        case submissionClientVersion = "submission_client_version"
        case mediaPlayer = "media_player"
        case tags
    }

    /// Creates additional info by decoding from the given decoder, skipping values of unexpected types.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let durationMs = try? container.decodeIfPresent(Double.self, forKey: .durationMs) {
            duration = durationMs / 1000
        } else {
            duration = try? container.decodeIfPresent(Double.self, forKey: .duration)
        }
        recordingMBID = try? container.decodeIfPresent(String.self, forKey: .recordingMBID)
        recordingMSID = try? container.decodeIfPresent(String.self, forKey: .recordingMSID)
        releaseMBID = try? container.decodeIfPresent(String.self, forKey: .releaseMBID)
        releaseGroupMBID = try? container.decodeIfPresent(String.self, forKey: .releaseGroupMBID)
        artistMBIDs = try? container.decodeIfPresent([String].self, forKey: .artistMBIDs)
        isrc = try? container.decodeIfPresent(String.self, forKey: .isrc)
        spotifyID = try? container.decodeIfPresent(String.self, forKey: .spotifyID)
        originURL = try? container.decodeIfPresent(String.self, forKey: .originURL)
        musicService = try? container.decodeIfPresent(String.self, forKey: .musicService)
        musicServiceName = try? container.decodeIfPresent(String.self, forKey: .musicServiceName)
        submissionClient = try? container.decodeIfPresent(String.self, forKey: .submissionClient)
        submissionClientVersion = try? container.decodeIfPresent(String.self, forKey: .submissionClientVersion)
        mediaPlayer = try? container.decodeIfPresent(String.self, forKey: .mediaPlayer)
        tags = try? container.decodeIfPresent([String].self, forKey: .tags)
    }
}
