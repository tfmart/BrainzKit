//
//  BZKManager+SubmitListens.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Submits a single listen for the signed-in user.
    ///
    /// Submit a listen once the user has listened to half the track or four minutes of it, whichever comes first.
    ///
    /// - Parameter listen: The listen to submit.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the listen.
    func submitListen(_ listen: BZKListenSubmission) async throws {
        try await send(submitListensRequest(.single, listens: [listen]))
    }

    /// Sets the signed-in user's now playing track.
    ///
    /// ListenBrainz only keeps the now playing track temporarily. Submit the listen with ``submitListen(_:)`` to keep it.
    ///
    /// - Parameter listen: The track that started playing. Its ``BZKListenSubmission/listenedAt`` is ignored.
    /// - Returns: The track's recording MSID, which you can use with ``submitFeedback(_:for:)``.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the request.
    @discardableResult
    func updatePlayingNow(_ listen: BZKListenSubmission) async throws -> String? {
        var request = try submitListensRequest(.playingNow, listens: [listen])
        request.queryItems = [URLQueryItem(name: "return_msid", value: "true")]
        let response: BZKSubmitListensResponse = try await perform(request)
        return response.recordingMSID
    }

    /// Submits listens that happened in the past, such as listens recorded while offline.
    ///
    /// - Parameter listens: Between 1 and 1000 listens.
    /// - Throws: ``BZKClientError/noListens`` or ``BZKClientError/tooManyListens`` if the count is out of range, ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the listens.
    func importListens(_ listens: [BZKListenSubmission]) async throws {
        guard !listens.isEmpty else { throw BZKClientError.noListens }
        guard listens.count <= 1000 else { throw BZKClientError.tooManyListens }
        try await send(submitListensRequest(.import, listens: listens))
    }

    /// Clears the signed-in user's now playing track.
    ///
    /// - Parameter onlyIfSubmittedByThisClient: When `true`, the track is cleared only if your app set it.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` with status 404 if another app set the track.
    func clearPlayingNow(onlyIfSubmittedByThisClient: Bool = true) async throws {
        let body = BZKClearPlayingNowBody(client: onlyIfSubmittedByThisClient ? clientInfo.name : nil)
        let request = try BZKRequest(method: .post, path: "playing-now/delete", body: encode(body), token: requiredToken())
        try await send(request)
    }

    /// Deletes one of the signed-in user's listens.
    ///
    /// ListenBrainz removes the listen in the background, so it may still appear for a short while.
    ///
    /// - Parameters:
    ///   - listenedAt: The listen's ``BZKListen/listenedAt``.
    ///   - recordingMSID: The listen's ``BZKListen/recordingMSID``.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the request.
    func deleteListen(listenedAt: Date, recordingMSID: String) async throws {
        let body = BZKDeleteListenBody(listenedAt: Int(listenedAt.timeIntervalSince1970), recordingMSID: recordingMSID)
        let request = try BZKRequest(method: .post, path: "delete-listen", body: encode(body), token: requiredToken())
        try await send(request)
    }
}

extension BZKManager {
    func submitListensRequest(_ listenType: BZKListenType, listens: [BZKListenSubmission]) throws -> BZKRequest {
        let body = BZKSubmitListensBody(listenType: listenType, listens: listens, clientInfo: clientInfo)
        return try BZKRequest(method: .post, path: "submit-listens", body: encode(body), token: requiredToken())
    }
}
