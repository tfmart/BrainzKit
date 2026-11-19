//
//  BZKMusicService.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A streaming service playlists can be imported from or exported to.
public enum BZKMusicService: String, Sendable, Hashable, CaseIterable {
    /// Spotify.
    case spotify
    /// Apple Music.
    case appleMusic = "apple_music"
    /// SoundCloud.
    case soundcloud
}
