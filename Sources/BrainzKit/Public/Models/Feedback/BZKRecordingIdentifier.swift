//
//  BZKRecordingIdentifier.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// Identifies a recording on ListenBrainz.
public enum BZKRecordingIdentifier: Sendable, Hashable {
    /// A MusicBrainz recording ID.
    case mbid(String)
    /// A ListenBrainz recording MSID, as returned by ``BZKManager/updatePlayingNow(_:)``.
    case msid(String)
}
