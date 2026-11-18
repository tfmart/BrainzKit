//
//  BZKListen.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A listen stored on ListenBrainz.
public struct BZKListen: Sendable, Hashable, Decodable {
    /// When playback started. `nil` for a now playing listen.
    public let listenedAt: Date?
    /// When ListenBrainz received the listen.
    public let insertedAt: Date?
    /// The ListenBrainz recording MSID, used to delete the listen or give feedback.
    public let recordingMSID: String?
    /// The name of the user who listened.
    public let userName: String?
    /// Whether this is the user's now playing track.
    public let isPlayingNow: Bool
    /// The track details.
    public let track: BZKTrackMetadata

    enum CodingKeys: String, CodingKey {
        case listenedAt = "listened_at"
        case insertedAt = "inserted_at"
        case recordingMSID = "recording_msid"
        case userName = "user_name"
        case isPlayingNow = "playing_now"
        case track = "track_metadata"
    }

    /// Creates a listen by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        listenedAt = try container.decodeIfPresent(Date.self, forKey: .listenedAt)
        insertedAt = try container.decodeIfPresent(Date.self, forKey: .insertedAt)
        recordingMSID = try container.decodeIfPresent(String.self, forKey: .recordingMSID)
        userName = try container.decodeIfPresent(String.self, forKey: .userName)
        isPlayingNow = try container.decodeIfPresent(Bool.self, forKey: .isPlayingNow) ?? false
        track = try container.decode(BZKTrackMetadata.self, forKey: .track)
    }
}
