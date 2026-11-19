//
//  BZKReviewEntityType.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The kind of MusicBrainz entity a review is about.
public enum BZKReviewEntityType: String, Sendable, Hashable, CaseIterable {
    /// An artist.
    case artist
    /// A release group, such as an album.
    case releaseGroup = "release_group"
    /// A recording.
    case recording
}
