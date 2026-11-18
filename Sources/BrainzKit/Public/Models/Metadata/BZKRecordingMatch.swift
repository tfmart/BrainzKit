//
//  BZKRecordingMatch.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A MusicBrainz recording matched from an artist and track name.
public struct BZKRecordingMatch: Sendable, Hashable, Decodable {
    /// The MusicBrainz recording ID.
    public let recordingMBID: String
    /// The recording name as it appears on MusicBrainz.
    public let recordingName: String
    /// The credited artist name as it appears on MusicBrainz.
    public let artistCreditName: String
    /// The MusicBrainz artist IDs.
    public let artistMBIDs: [String]
    /// The MusicBrainz release ID, if matched.
    public let releaseMBID: String?
    /// The release name, if matched.
    public let releaseName: String?

    enum CodingKeys: String, CodingKey {
        case recordingMBID = "recording_mbid"
        case recordingName = "recording_name"
        case artistCreditName = "artist_credit_name"
        case artistMBIDs = "artist_mbids"
        case releaseMBID = "release_mbid"
        case releaseName = "release_name"
    }
}
