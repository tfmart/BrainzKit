//
//  BZKManager+Playlists.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Fetches the playlists a user created.
    ///
    /// Private playlists are included only when the signed-in user is the owner.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - count: The number of playlists to return.
    ///   - offset: The number of playlists to skip.
    /// - Returns: A page of playlists, without their tracks.
    func playlists(forUser userName: String, count: Int = 25, offset: Int = 0) async throws -> BZKPlaylistPage {
        try await playlistPage(path: "user/\(BZKRequest.segment(userName))/playlists", count: count, offset: offset)
    }

    /// Fetches the playlists ListenBrainz generated for a user, such as Daily Jams and Weekly Exploration.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - count: The number of playlists to return.
    ///   - offset: The number of playlists to skip.
    /// - Returns: A page of playlists, newest first, without their tracks.
    func playlists(createdFor userName: String, count: Int = 25, offset: Int = 0) async throws -> BZKPlaylistPage {
        try await playlistPage(path: "user/\(BZKRequest.segment(userName))/playlists/createdfor", count: count, offset: offset)
    }

    /// Fetches the playlists a user can edit as a collaborator.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - count: The number of playlists to return.
    ///   - offset: The number of playlists to skip.
    /// - Returns: A page of playlists, without their tracks.
    func collaborativePlaylists(forUser userName: String, count: Int = 25, offset: Int = 0) async throws -> BZKPlaylistPage {
        try await playlistPage(path: "user/\(BZKRequest.segment(userName))/playlists/collaborator", count: count, offset: offset)
    }

    /// Fetches the current recommendation playlists ListenBrainz shows on a user's recommendations page.
    ///
    /// - Parameter userName: The ListenBrainz user name.
    /// - Returns: The playlists, without their tracks.
    func recommendedPlaylists(forUser userName: String) async throws -> [BZKPlaylist] {
        let request = BZKRequest(path: "user/\(BZKRequest.segment(userName))/playlists/recommendations")
        let page: BZKPlaylistPage = try await perform(request)
        return page.playlists
    }

    /// Searches playlist titles and descriptions.
    ///
    /// - Parameters:
    ///   - query: The text to search for, at least three characters long.
    ///   - userName: A user whose playlists to search. When `nil`, all public playlists are searched.
    ///   - count: The number of playlists to return.
    ///   - offset: The number of playlists to skip.
    /// - Returns: A page of playlists, best match first, without their tracks.
    /// - Throws: ``BZKError`` with status 400 if the query is shorter than three characters.
    func searchPlaylists(_ query: String, forUser userName: String? = nil, count: Int = 25, offset: Int = 0) async throws -> BZKPlaylistPage {
        let path = userName.map { "user/\(BZKRequest.segment($0))/playlists/search" } ?? "playlist/search"
        let request = BZKRequest(
            path: path,
            queryItems: BZKRequest.query(["query": query, "count": String(count), "offset": String(offset)])
        )
        return try await perform(request)
    }

    /// Fetches a playlist with its tracks.
    ///
    /// - Parameters:
    ///   - id: The playlist's MusicBrainz ID.
    ///   - includeTrackMetadata: Whether to include each track's artists and cover art. Turning this off makes the request faster.
    /// - Returns: The playlist.
    /// - Throws: ``BZKError`` with status 404 if the playlist doesn't exist or is private to another user.
    func playlist(id: String, includeTrackMetadata: Bool = true) async throws -> BZKPlaylist {
        let request = BZKRequest(
            path: "playlist/\(BZKRequest.segment(id))",
            queryItems: includeTrackMetadata ? [] : BZKRequest.query(["fetch_metadata": "false"])
        )
        let response: BZKPlaylistEnvelope = try await perform(request)
        return response.playlist
    }
}

extension BZKManager {
    func playlistPage(path: String, count: Int, offset: Int) async throws -> BZKPlaylistPage {
        let request = BZKRequest(
            path: path,
            queryItems: BZKRequest.query(["count": String(count), "offset": String(offset)])
        )
        return try await perform(request)
    }
}
