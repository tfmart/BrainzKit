//
//  BZKFreshReleaseSort.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// How fresh releases are ordered.
public enum BZKFreshReleaseSort: String, Sendable, Hashable, CaseIterable {
    /// By release date.
    case releaseDate = "release_date"
    /// By artist name.
    case artistName = "artist_credit_name"
    /// By release name.
    case releaseName = "release_name"
}
