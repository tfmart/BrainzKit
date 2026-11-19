//
//  BZKManager+Feedback.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Loves, hates, or clears the signed-in user's feedback on a recording.
    ///
    /// - Parameters:
    ///   - score: The feedback to give. Pass ``BZKFeedbackScore/neutral`` to remove existing feedback.
    ///   - recording: The recording to give feedback on.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the request.
    func submitFeedback(_ score: BZKFeedbackScore, for recording: BZKRecordingIdentifier) async throws {
        let body = BZKFeedbackBody(score: score, recording: recording)
        let request = try BZKRequest(method: .post, path: "feedback/recording-feedback", body: encode(body), token: requiredToken())
        try await send(request)
    }

    /// Fetches the feedback a user has given.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - score: Only return feedback with this score. Pass `nil` to return loved and hated recordings.
    ///   - count: The number of items to return.
    ///   - offset: The number of items to skip.
    ///   - includeMetadata: Whether each item should include the recording's ``BZKFeedback/track`` metadata.
    /// - Returns: A page of feedback.
    func feedback(
        forUser userName: String,
        score: BZKFeedbackScore? = nil,
        count: Int = 25,
        offset: Int = 0,
        includeMetadata: Bool = false
    ) async throws -> BZKFeedbackPage {
        let request = BZKRequest(
            path: "feedback/user/\(BZKRequest.segment(userName))/get-feedback",
            queryItems: BZKRequest.query([
                "score": score.map { String($0.rawValue) },
                "count": String(count),
                "offset": String(offset),
                "metadata": includeMetadata ? "true" : nil
            ])
        )
        return try await perform(request)
    }

    /// Fetches a user's feedback for specific recordings.
    ///
    /// Recordings the user has not given feedback on are returned with a ``BZKFeedbackScore/neutral`` score.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - recordings: The recordings to look up.
    /// - Returns: The user's feedback for each recording.
    func feedback(forUser userName: String, recordings: [BZKRecordingIdentifier]) async throws -> [BZKFeedback] {
        var mbids: [String] = []
        var msids: [String] = []
        for recording in recordings {
            switch recording {
            case .mbid(let mbid): mbids.append(mbid)
            case .msid(let msid): msids.append(msid)
            }
        }
        let request = try BZKRequest(
            method: .post,
            path: "feedback/user/\(BZKRequest.segment(userName))/get-feedback-for-recordings",
            body: encode(BZKFeedbackLookupBody(recordingMBIDs: mbids, recordingMSIDs: msids))
        )
        let response: BZKFeedbackList = try await perform(request)
        return response.feedback
    }

    /// Fetches the feedback every user has given a recording.
    ///
    /// - Parameters:
    ///   - recording: The recording.
    ///   - score: Only return feedback with this score. When `nil`, loves and hates are both returned.
    ///   - count: The number of items to return.
    ///   - offset: The number of items to skip.
    /// - Returns: A page of feedback, each with the ``BZKFeedback/userName`` of who gave it.
    func feedback(
        forRecording recording: BZKRecordingIdentifier,
        score: BZKFeedbackScore? = nil,
        count: Int = 25,
        offset: Int = 0
    ) async throws -> BZKFeedbackPage {
        let path: String
        switch recording {
        case .mbid(let mbid): path = "feedback/recording/\(BZKRequest.segment(mbid))/get-feedback-mbid"
        case .msid(let msid): path = "feedback/recording/\(BZKRequest.segment(msid))/get-feedback"
        }
        let request = BZKRequest(
            path: path,
            queryItems: BZKRequest.query([
                "score": score.map { String($0.rawValue) },
                "count": String(count),
                "offset": String(offset)
            ])
        )
        return try await perform(request)
    }

    /// Imports loved tracks from another service as loved recordings for the signed-in user.
    ///
    /// - Parameter source: The service and account to import from.
    /// - Returns: How many tracks were found and imported.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the account can't be read, such as a Navidrome server that isn't connected.
    @discardableResult
    func importLovedTracks(from source: BZKFeedbackImportSource) async throws -> BZKFeedbackImportResult {
        let request = try BZKRequest(method: .post, path: "feedback/import", body: encode(BZKFeedbackImportBody(source: source)), token: requiredToken())
        return try await perform(request)
    }
}
