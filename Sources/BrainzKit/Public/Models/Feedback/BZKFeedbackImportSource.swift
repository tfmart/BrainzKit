//
//  BZKFeedbackImportSource.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A service to import loved tracks from.
public enum BZKFeedbackImportSource: Sendable, Hashable {
    /// A Last.fm account's loved tracks.
    case lastFM(userName: String)
    /// A Libre.fm account's loved tracks.
    case libreFM(userName: String)
    /// Starred tracks from the Navidrome server connected on listenbrainz.org.
    case navidrome
}
