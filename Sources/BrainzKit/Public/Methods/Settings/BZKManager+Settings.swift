//
//  BZKManager+Settings.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Sets or removes the signed-in user's flair. Flairs are a perk for ListenBrainz donors.
    ///
    /// - Parameter flair: The flair, or `nil` to remove it.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the change.
    func setFlair(_ flair: BZKFlair?) async throws {
        try await send(BZKRequest(method: .post, path: "settings/flair", body: encode(BZKFlairBody(flair: flair)), token: requiredToken()))
    }

    /// Sets the signed-in user's time zone, which ListenBrainz uses to schedule generated playlists.
    ///
    /// - Parameter timeZone: The time zone. Its identifier, such as "Europe/Lisbon", is sent to ListenBrainz.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the time zone.
    func setTimeZone(_ timeZone: TimeZone) async throws {
        let body = ["zonename": timeZone.identifier]
        try await send(BZKRequest(method: .post, path: "settings/timezone", body: encode(body), token: requiredToken()))
    }

    /// Sets whether ListenBrainz copies the signed-in user's generated playlists, such as Daily Jams, to their connected Spotify account.
    ///
    /// - Parameter enabled: Whether to copy playlists to Spotify.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    func setExportsGeneratedPlaylistsToSpotify(_ enabled: Bool) async throws {
        let body = ["export_to_spotify": enabled]
        try await send(BZKRequest(method: .post, path: "settings/troi", body: encode(body), token: requiredToken()))
    }

    /// Replaces the signed-in user's BrainzPlayer preferences on listenbrainz.org.
    ///
    /// - Parameter preferences: The new preferences. They replace all current preferences, so include every value you want to keep.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the preferences.
    func setBrainzPlayerPreferences(_ preferences: BZKBrainzPlayerPreferences) async throws {
        try await send(BZKRequest(method: .post, path: "settings/brainzplayer", body: encode(preferences), token: requiredToken()))
    }
}
