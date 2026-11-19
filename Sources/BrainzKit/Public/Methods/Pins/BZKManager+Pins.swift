//
//  BZKManager+Pins.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Fetches a user's pinned recordings, including expired pins.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - count: The number of pins to return, up to 1000.
    ///   - offset: The number of pins to skip.
    /// - Returns: A page of pins, newest first.
    func pins(forUser userName: String, count: Int = 25, offset: Int = 0) async throws -> BZKPinnedRecordingPage {
        let request = BZKRequest(
            path: "\(BZKRequest.segment(userName))/pins",
            queryItems: BZKRequest.query(["count": String(count), "offset": String(offset)])
        )
        return try await perform(request)
    }

    /// Fetches the recording a user currently has pinned.
    ///
    /// - Parameter userName: The ListenBrainz user name.
    /// - Returns: The active pin, or `nil` if the user has none.
    func currentPin(forUser userName: String) async throws -> BZKPinnedRecording? {
        let request = BZKRequest(path: "\(BZKRequest.segment(userName))/pins/current")
        let response: BZKPinnedRecordingResponse = try await perform(request)
        return response.pin
    }

    /// Fetches recent pins from the users a user follows.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - count: The number of pins to return, up to 1000.
    ///   - offset: The number of pins to skip.
    /// - Returns: Pins from followed users, newest first. Each pin's ``BZKPinnedRecording/userName`` names who pinned it.
    func pinsFromFollowing(forUser userName: String, count: Int = 25, offset: Int = 0) async throws -> [BZKPinnedRecording] {
        let request = BZKRequest(
            path: "\(BZKRequest.segment(userName))/pins/following",
            queryItems: BZKRequest.query(["count": String(count), "offset": String(offset)])
        )
        let response: BZKPinnedRecordingList = try await perform(request)
        return response.pins
    }

    /// Pins a recording to the signed-in user's profile, replacing any active pin.
    ///
    /// - Parameters:
    ///   - recording: The recording to pin.
    ///   - blurb: A message to show with the pin.
    ///   - until: When the pin should expire. ListenBrainz uses one week when this is `nil`.
    /// - Returns: The new pin.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the pin.
    @discardableResult
    func pin(_ recording: BZKRecordingIdentifier, blurb: String? = nil, until: Date? = nil) async throws -> BZKPinnedRecording {
        let body = BZKPinBody(recording: recording, blurb: blurb, pinnedUntil: until)
        let request = try BZKRequest(method: .post, path: "pin", body: encode(body), token: requiredToken())
        let response: BZKPinnedRecordingResponse = try await perform(request)
        guard let pin = response.pin else { throw BZKClientError.invalidResponse }
        return pin
    }

    /// Unpins the signed-in user's active pin. The pin stays in their pin history.
    ///
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` with status 404 if no pin is active.
    func unpin() async throws {
        let request = try BZKRequest(method: .post, path: "pin/unpin", token: requiredToken())
        try await send(request)
    }

    /// Permanently deletes one of the signed-in user's pins, removing it from their pin history.
    ///
    /// - Parameter id: The pin's ``BZKPinnedRecording/id``.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` with status 404 if the user has no pin with that ID.
    func deletePin(id: Int) async throws {
        let request = try BZKRequest(method: .post, path: "pin/delete/\(id)", token: requiredToken())
        try await send(request)
    }

    /// Changes the message on one of the signed-in user's pins.
    ///
    /// - Parameters:
    ///   - id: The pin's ``BZKPinnedRecording/id``.
    ///   - blurb: The new message.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the change.
    func updatePin(id: Int, blurb: String) async throws {
        let request = try BZKRequest(method: .post, path: "pin/update/\(id)", body: encode(BZKPinBlurbBody(blurb: blurb)), token: requiredToken())
        try await send(request)
    }
}
