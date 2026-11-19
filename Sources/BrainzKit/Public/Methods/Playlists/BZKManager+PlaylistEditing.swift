//
//  BZKManager+PlaylistEditing.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Creates a playlist owned by the signed-in user.
    ///
    /// - Parameters:
    ///   - title: The playlist's title.
    ///   - description: The playlist's description.
    ///   - isPublic: Whether anyone can see the playlist.
    ///   - collaborators: User names of people who can also edit the playlist.
    ///   - recordingMBIDs: MusicBrainz recording IDs of the playlist's first tracks, in order.
    /// - Returns: The new playlist's ID.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the playlist, such as for an unknown collaborator.
    @discardableResult
    func createPlaylist(
        title: String,
        description: String? = nil,
        isPublic: Bool = true,
        collaborators: [String] = [],
        recordingMBIDs: [String] = []
    ) async throws -> String {
        let payload = BZKPlaylistWritePayload(
            title: title,
            annotation: description,
            isPublic: isPublic,
            collaborators: collaborators,
            recordingMBIDs: recordingMBIDs
        )
        let request = try BZKRequest(method: .post, path: "playlist/create", body: encode(BZKPlaylistWriteBody(playlist: payload)), token: requiredToken())
        let response: BZKPlaylistCreatedResponse = try await perform(request)
        return response.playlistMBID
    }

    /// Changes a playlist's title, description, visibility, or collaborators. Pass `nil` to leave a value unchanged.
    ///
    /// - Parameters:
    ///   - id: The playlist's ID.
    ///   - title: The new title.
    ///   - description: The new description. Pass an empty string to remove it.
    ///   - isPublic: Whether anyone can see the playlist.
    ///   - collaborators: The new list of collaborators, replacing the current one.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the user can't edit the playlist.
    func editPlaylist(
        id: String,
        title: String? = nil,
        description: String? = nil,
        isPublic: Bool? = nil,
        collaborators: [String]? = nil
    ) async throws {
        let token = try requiredToken()
        var keptCollaborators = collaborators
        if keptCollaborators == nil {
            keptCollaborators = try await playlist(id: id, includeTrackMetadata: false).collaborators
        }
        let payload = BZKPlaylistWritePayload(
            title: title,
            annotation: description,
            isPublic: isPublic,
            collaborators: keptCollaborators,
            recordingMBIDs: nil
        )
        let request = try BZKRequest(method: .post, path: "playlist/edit/\(BZKRequest.segment(id))", body: encode(BZKPlaylistWriteBody(playlist: payload)), token: token)
        try await send(request)
    }

    /// Permanently deletes a playlist the signed-in user owns.
    ///
    /// - Parameter id: The playlist's ID.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the user doesn't own the playlist.
    func deletePlaylist(id: String) async throws {
        let request = try BZKRequest(method: .post, path: "playlist/\(BZKRequest.segment(id))/delete", token: requiredToken())
        try await send(request)
    }

    /// Copies a playlist into the signed-in user's playlists.
    ///
    /// - Parameter id: The ID of the playlist to copy.
    /// - Returns: The copy's ID.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the playlist can't be copied.
    @discardableResult
    func copyPlaylist(id: String) async throws -> String {
        let request = try BZKRequest(method: .post, path: "playlist/\(BZKRequest.segment(id))/copy", token: requiredToken())
        let response: BZKPlaylistCreatedResponse = try await perform(request)
        return response.playlistMBID
    }

    /// Adds tracks to a playlist.
    ///
    /// - Parameters:
    ///   - recordingMBIDs: MusicBrainz recording IDs of the tracks to add, in order. Any number can be added at once.
    ///   - id: The playlist's ID.
    ///   - position: The zero-based position to insert the tracks at. When `nil`, they're added to the end.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the user can't edit the playlist.
    func addTracks(_ recordingMBIDs: [String], toPlaylist id: String, at position: Int? = nil) async throws {
        let token = try requiredToken()
        let batchSize = 100
        for start in stride(from: 0, to: recordingMBIDs.count, by: batchSize) {
            let batch = Array(recordingMBIDs[start..<min(start + batchSize, recordingMBIDs.count)])
            let payload = BZKPlaylistWritePayload(title: nil, annotation: nil, isPublic: nil, collaborators: nil, recordingMBIDs: batch)
            let path = "playlist/\(BZKRequest.segment(id))/item/add" + (position.map { "/\($0 + start)" } ?? "")
            let request = try BZKRequest(method: .post, path: path, body: encode(BZKPlaylistWriteBody(playlist: payload)), token: token)
            try await send(request)
        }
    }

    /// Moves tracks to a new position in a playlist.
    ///
    /// - Parameters:
    ///   - id: The playlist's ID.
    ///   - from: The zero-based position of the first track to move.
    ///   - to: The zero-based position to move the tracks to.
    ///   - count: The number of consecutive tracks to move.
    ///   - recordingMBID: The MusicBrainz recording ID of the track at `from`, which ListenBrainz uses to confirm the move.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the user can't edit the playlist.
    func moveTracks(inPlaylist id: String, from: Int, to: Int, count: Int = 1, recordingMBID: String) async throws {
        let body = BZKPlaylistMoveBody(mbid: recordingMBID, from: from, to: to, count: count)
        let request = try BZKRequest(method: .post, path: "playlist/\(BZKRequest.segment(id))/item/move", body: encode(body), token: requiredToken())
        try await send(request)
    }

    /// Removes tracks from a playlist.
    ///
    /// - Parameters:
    ///   - id: The playlist's ID.
    ///   - position: The zero-based position of the first track to remove.
    ///   - count: The number of consecutive tracks to remove.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the user can't edit the playlist.
    func removeTracks(fromPlaylist id: String, at position: Int, count: Int = 1) async throws {
        let body = BZKPlaylistRemoveBody(index: position, count: count)
        let request = try BZKRequest(method: .post, path: "playlist/\(BZKRequest.segment(id))/item/delete", body: encode(body), token: requiredToken())
        try await send(request)
    }
}
