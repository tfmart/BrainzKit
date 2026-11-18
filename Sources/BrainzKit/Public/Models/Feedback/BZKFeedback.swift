//
//  BZKFeedback.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A user's feedback on a recording.
public struct BZKFeedback: Sendable, Hashable, Decodable {
    /// The feedback score.
    public let score: BZKFeedbackScore
    /// The MusicBrainz recording ID, if known.
    public let recordingMBID: String?
    /// The ListenBrainz recording MSID, if known.
    public let recordingMSID: String?
    /// When the feedback was given.
    public let created: Date?
    /// The name of the user who gave the feedback.
    public let userName: String?
    /// The recording's metadata, present when it was requested.
    public let track: BZKTrackMetadata?

    enum CodingKeys: String, CodingKey {
        case score
        case recordingMBID = "recording_mbid"
        case recordingMSID = "recording_msid"
        case created
        case userName = "user_id"
        case track = "track_metadata"
    }
}
