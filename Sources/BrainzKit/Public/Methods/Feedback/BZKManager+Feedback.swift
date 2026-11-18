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
        let request = BZKRequest(
            path: "feedback/user/\(BZKRequest.segment(userName))/get-feedback-for-recordings",
            queryItems: BZKRequest.query([
                "recording_mbids": mbids.isEmpty ? nil : mbids.joined(separator: ","),
                "recording_msids": msids.isEmpty ? nil : msids.joined(separator: ",")
            ])
        )
        let response: BZKFeedbackList = try await perform(request)
        return response.feedback
    }
}
