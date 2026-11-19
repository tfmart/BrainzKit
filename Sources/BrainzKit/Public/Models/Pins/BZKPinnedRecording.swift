//
//  BZKPinnedRecording.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A recording a user pinned to their profile, with an optional message.
public struct BZKPinnedRecording: Sendable, Hashable, Decodable, Identifiable {
    /// The pin's ID, used to update or delete it.
    public let id: Int
    /// The MusicBrainz recording ID, if known.
    public let recordingMBID: String?
    /// The ListenBrainz recording MSID, if known.
    public let recordingMSID: String?
    /// The message the user wrote with the pin.
    public let blurb: String?
    /// When the recording was pinned.
    public let createdAt: Date
    /// When the pin expires.
    public let pinnedUntil: Date
    /// The name of the user who pinned the recording. Present in pins from followed users.
    public let userName: String?
    /// The recording's metadata, if available.
    public let track: BZKTrackMetadata?

    enum CodingKeys: String, CodingKey {
        case id = "row_id"
        case recordingMBID = "recording_mbid"
        case recordingMSID = "recording_msid"
        case blurb = "blurb_content"
        case createdAt = "created"
        case pinnedUntil = "pinned_until"
        case userName = "user_name"
        case track = "track_metadata"
    }
}
