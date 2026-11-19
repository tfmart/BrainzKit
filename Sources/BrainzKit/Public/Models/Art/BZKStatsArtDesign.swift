//
//  BZKStatsArtDesign.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A shareable image design for a user's top artists or releases.
public enum BZKStatsArtDesign: String, Sendable, Hashable, CaseIterable {
    /// The user's top 5 artists.
    case topFiveArtists = "designer-top-5"
    /// The user's top 10 releases.
    case topTenReleases = "designer-top-10"
    /// The user's top 10 releases, in an alternate layout.
    case topTenReleasesAlternate = "designer-top-10-alt"
    /// The user's top releases as records on a floor.
    case lpsOnTheFloor = "lps-on-the-floor"
}
