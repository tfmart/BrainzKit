//
//  BZKManager+PlaylistServices.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Fetches a playlist as an XSPF document, a standard playlist format many media players open.
    ///
    /// - Parameters:
    ///   - id: The playlist's ID.
    ///   - includeTrackMetadata: Whether to include each track's details. Turning this off makes the request faster.
    /// - Returns: The XSPF document's XML data.
    /// - Throws: ``BZKError`` with status 404 if the playlist doesn't exist or is private to another user.
    func playlistXSPF(id: String, includeTrackMetadata: Bool = true) async throws -> Data {
        let request = BZKRequest(
            path: "playlist/\(BZKRequest.segment(id))/xspf",
            queryItems: includeTrackMetadata ? [] : BZKRequest.query(["fetch_metadata": "false"])
        )
        return try await send(request)
    }

    /// Fetches the playlists in the signed-in user's account on a streaming service they connected on listenbrainz.org.
    ///
    /// - Parameter service: The streaming service.
    /// - Returns: The service's playlists.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the service isn't connected.
    func servicePlaylists(on service: BZKMusicService) async throws -> [BZKServicePlaylist] {
        try await perform(BZKRequest(path: "playlist/import/\(service.rawValue)", token: requiredToken()))
    }

    /// Copies a playlist from a streaming service into the signed-in user's ListenBrainz playlists, matching its tracks to MusicBrainz recordings.
    ///
    /// - Parameters:
    ///   - playlistID: The playlist's ID on the service, such as a ``BZKServicePlaylist/id``.
    ///   - service: The streaming service.
    /// - Returns: The new ListenBrainz playlist's ID.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the service isn't connected or the playlist can't be read.
    @discardableResult
    func importPlaylist(_ playlistID: String, from service: BZKMusicService) async throws -> String {
        let request = try BZKRequest(path: "playlist/\(service.rawValue)/\(BZKRequest.segment(playlistID))/tracks", token: requiredToken())
        let response: BZKImportedPlaylistResponse = try await perform(request)
        return response.playlistID
    }

    /// Copies a ListenBrainz playlist to the signed-in user's account on a streaming service.
    ///
    /// - Parameters:
    ///   - id: The ListenBrainz playlist's ID.
    ///   - service: The streaming service.
    ///   - isPublic: Whether the copy is public on the service.
    /// - Returns: The copy's URL on the service.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the service isn't connected.
    @discardableResult
    func exportPlaylist(id: String, to service: BZKMusicService, isPublic: Bool = true) async throws -> URL {
        let request = try BZKRequest(
            method: .post,
            path: "playlist/\(BZKRequest.segment(id))/export/\(service.rawValue)",
            queryItems: BZKRequest.query(["is_public": isPublic ? "true" : "false"]),
            token: requiredToken()
        )
        let response: BZKExportedPlaylistResponse = try await perform(request)
        return response.externalURL
    }

    /// Creates a playlist on a streaming service from recordings, without saving it on ListenBrainz. Useful for keeping an LB Radio playlist.
    ///
    /// - Parameters:
    ///   - title: The playlist's title.
    ///   - recordingMBIDs: MusicBrainz recording IDs of the tracks, in order.
    ///   - service: The streaming service.
    ///   - isPublic: Whether the playlist is public on the service.
    /// - Returns: The playlist's URL on the service.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the service isn't connected.
    @discardableResult
    func exportPlaylist(title: String, recordingMBIDs: [String], to service: BZKMusicService, isPublic: Bool = true) async throws -> URL {
        let payload = BZKPlaylistWritePayload(title: title, annotation: nil, isPublic: nil, collaborators: nil, recordingMBIDs: recordingMBIDs)
        let request = try BZKRequest(
            method: .post,
            path: "playlist/export-jspf/\(service.rawValue)",
            queryItems: BZKRequest.query(["is_public": isPublic ? "true" : "false"]),
            body: encode(payload),
            token: requiredToken()
        )
        let response: BZKExportedPlaylistResponse = try await perform(request)
        return response.externalURL
    }
}
