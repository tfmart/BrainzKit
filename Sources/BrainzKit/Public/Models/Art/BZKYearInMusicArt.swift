//
//  BZKYearInMusicArt.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A shareable Year in Music image.
public enum BZKYearInMusicArt: String, Sendable, Hashable, CaseIterable {
    /// Listening totals for the year.
    case stats
    /// The year's top artists.
    case artists
    /// The year's top albums.
    case albums
    /// The year's top tracks.
    case tracks
    /// The year's top discoveries playlist.
    case discoveryPlaylist = "discovery-playlist"
    /// The playlist of tracks similar users loved and the user missed.
    case missedPlaylist = "missed-playlist"
}
