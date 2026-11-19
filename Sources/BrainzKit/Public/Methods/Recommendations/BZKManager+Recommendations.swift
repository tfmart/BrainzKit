//
//  BZKManager+Recommendations.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Fetches recordings ListenBrainz recommends to a user based on what similar listeners play.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - count: The number of recordings to return.
    ///   - offset: The number of recordings to skip.
    /// - Returns: A page of recommendations, strongest first.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has no recommendations for the user, such as when they have no recent listens.
    func recommendedRecordings(forUser userName: String, count: Int = 25, offset: Int = 0) async throws -> BZKRecommendationPage {
        let request = BZKRequest(
            path: "cf/recommendation/user/\(BZKRequest.segment(userName))/recording",
            queryItems: BZKRequest.query(["count": String(count), "offset": String(offset)])
        )
        let response: BZKPayloadResponse<BZKRecommendationPage> = try await perform(request)
        return response.payload
    }

    /// Rates a recording ListenBrainz recommended to the signed-in user, which improves future recommendations.
    ///
    /// - Parameters:
    ///   - rating: The rating. It replaces any earlier rating of the recording.
    ///   - recordingMBID: The recommended recording's MusicBrainz ID.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the rating.
    func rateRecommendation(_ rating: BZKRecommendationRating, recordingMBID: String) async throws {
        let body = BZKRecommendationFeedbackBody(recordingMBID: recordingMBID, rating: rating)
        let request = try BZKRequest(method: .post, path: "recommendation/feedback/submit", body: encode(body), token: requiredToken())
        try await send(request)
    }

    /// Removes the signed-in user's rating of a recommended recording.
    ///
    /// - Parameter recordingMBID: The recommended recording's MusicBrainz ID.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the request.
    func removeRecommendationRating(recordingMBID: String) async throws {
        let body = BZKRecommendationFeedbackBody(recordingMBID: recordingMBID, rating: nil)
        let request = try BZKRequest(method: .post, path: "recommendation/feedback/delete", body: encode(body), token: requiredToken())
        try await send(request)
    }

    /// Fetches a user's ratings of recommended recordings.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - rating: Only return ratings of this kind. When `nil`, all ratings are returned.
    ///   - count: The number of ratings to return.
    ///   - offset: The number of ratings to skip.
    /// - Returns: A page of ratings, newest first.
    func recommendationRatings(
        forUser userName: String,
        rating: BZKRecommendationRating? = nil,
        count: Int = 25,
        offset: Int = 0
    ) async throws -> BZKRecommendationFeedbackPage {
        let request = BZKRequest(
            path: "recommendation/feedback/user/\(BZKRequest.segment(userName))",
            queryItems: BZKRequest.query([
                "rating": rating?.rawValue,
                "count": String(count),
                "offset": String(offset)
            ])
        )
        return try await perform(request)
    }

    /// Fetches a user's ratings of specific recommended recordings.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - recordingMBIDs: The MusicBrainz recording IDs to look up.
    /// - Returns: The ratings the user has given. Recordings without a rating are left out.
    func recommendationRatings(forUser userName: String, recordingMBIDs: [String]) async throws -> [BZKRecommendationFeedback] {
        let request = BZKRequest(
            path: "recommendation/feedback/user/\(BZKRequest.segment(userName))/recordings",
            queryItems: BZKRequest.query(["mbids": recordingMBIDs.joined(separator: ",")])
        )
        let response: BZKRecommendationFeedbackList = try await perform(request)
        return response.feedback
    }
}
