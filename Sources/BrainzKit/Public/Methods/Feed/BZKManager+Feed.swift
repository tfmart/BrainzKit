//
//  BZKManager+Feed.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Fetches the signed-in user's feed: pins, recommendations, follows, and other events from the people they follow.
    ///
    /// - Parameters:
    ///   - before: Only return events before this date. When both dates are `nil`, the newest events are returned.
    ///   - after: Only return events after this date.
    ///   - count: The number of events to return, up to 1000.
    /// - Returns: Events, newest first.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    func feedEvents(before: Date? = nil, after: Date? = nil, count: Int = 25) async throws -> [BZKFeedEvent] {
        try await feed(path: "feed/events", before: before, after: after, count: count)
    }

    /// Fetches recent listens from the people the signed-in user follows.
    ///
    /// - Parameters:
    ///   - before: Only return listens before this date.
    ///   - after: Only return listens after this date.
    ///   - count: The number of listens to return, up to 1000.
    /// - Returns: Listen events, newest first.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    func feedListensFromFollowing(before: Date? = nil, after: Date? = nil, count: Int = 25) async throws -> [BZKFeedEvent] {
        try await feed(path: "feed/events/listens/following", before: before, after: after, count: count)
    }

    /// Fetches recent listens from users with taste similar to the signed-in user's.
    ///
    /// - Parameters:
    ///   - before: Only return listens before this date.
    ///   - after: Only return listens after this date.
    ///   - count: The number of listens to return, up to 1000.
    /// - Returns: Listen events, newest first, each with the user's ``BZKFeedEvent/similarity``.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    func feedListensFromSimilarUsers(before: Date? = nil, after: Date? = nil, count: Int = 25) async throws -> [BZKFeedEvent] {
        try await feed(path: "feed/events/listens/similar", before: before, after: after, count: count)
    }

    /// Recommends a recording to everyone who follows the signed-in user.
    ///
    /// - Parameter recording: The recording to recommend.
    /// - Returns: The new event's ID, which you can pass to ``deleteFeedEvent(id:kind:)``.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if ListenBrainz rejects the recommendation.
    @discardableResult
    func recommendToFollowers(_ recording: BZKRecordingIdentifier) async throws -> Int {
        let metadata = BZKRecommendationEventMetadata(recording: recording, users: nil, blurb: nil)
        return try await createEvent(path: "timeline-event/create/recording", metadata: metadata)
    }

    /// Recommends a recording to specific users, with an optional message.
    ///
    /// - Parameters:
    ///   - recording: The recording to recommend.
    ///   - users: User names of the recipients. Each one must follow the signed-in user.
    ///   - message: A message to show with the recommendation.
    /// - Returns: The new event's ID, which you can pass to ``deleteFeedEvent(id:kind:)``.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if a recipient doesn't follow the signed-in user.
    @discardableResult
    func recommend(_ recording: BZKRecordingIdentifier, to users: [String], message: String? = nil) async throws -> Int {
        let metadata = BZKRecommendationEventMetadata(recording: recording, users: users, blurb: message)
        return try await createEvent(path: "timeline-event/create/recommend-personal", metadata: metadata)
    }

    /// Publishes a review on CritiqueBrainz and shares it in the signed-in user's feed.
    ///
    /// The user must have connected their CritiqueBrainz account on listenbrainz.org.
    ///
    /// - Parameters:
    ///   - text: The review text.
    ///   - entityMBID: The MusicBrainz ID of the artist, release group, or recording.
    ///   - entityName: The name of the artist, release group, or recording.
    ///   - entityType: The kind of entity being reviewed.
    ///   - language: The review's language as an ISO 639-1 code, such as "en".
    ///   - rating: A rating from 1 to 5.
    /// - Returns: The new feed event's ID.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the user hasn't connected CritiqueBrainz or the review is invalid.
    @discardableResult
    func postReview(
        _ text: String,
        of entityMBID: String,
        named entityName: String,
        type entityType: BZKReviewEntityType,
        language: String,
        rating: Int? = nil
    ) async throws -> Int {
        let metadata = BZKReviewEventMetadata(
            entityName: entityName,
            entityID: entityMBID,
            entityType: entityType.rawValue,
            text: text,
            language: language,
            rating: rating
        )
        let request = try BZKRequest(
            method: .post,
            path: "\(signedInUserPath())/timeline-event/create/review",
            body: encode(BZKReviewEventBody(metadata: metadata))
        )
        let response: BZKCreatedEvent = try await perform(request)
        return response.id
    }

    /// Deletes one of the signed-in user's own recommendations or notifications from their feed.
    ///
    /// - Parameters:
    ///   - id: The event's ID.
    ///   - kind: The event's kind: ``BZKFeedEventKind/recordingRecommendation``, ``BZKFeedEventKind/personalRecommendation``, or ``BZKFeedEventKind/notification``.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` with status 404 if the user has no such event.
    func deleteFeedEvent(id: Int, kind: BZKFeedEventKind) async throws {
        try await sendEventReference(path: "feed/events/delete", reference: BZKFeedEventReference(kind: kind, id: id, idKey: "id"))
    }

    /// Hides another user's recommendation or pin from the signed-in user's feed.
    ///
    /// - Parameters:
    ///   - id: The event's ID.
    ///   - kind: The event's kind: ``BZKFeedEventKind/recordingRecommendation``, ``BZKFeedEventKind/personalRecommendation``, ``BZKFeedEventKind/pin``, or ``BZKFeedEventKind/notification``.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the event can't be hidden.
    func hideFeedEvent(id: Int, kind: BZKFeedEventKind) async throws {
        try await sendEventReference(path: "feed/events/hide", reference: BZKFeedEventReference(kind: kind, id: id, idKey: "event_id"))
    }

    /// Shows an event the signed-in user hid with ``hideFeedEvent(id:kind:)`` again.
    ///
    /// - Parameters:
    ///   - id: The event's ID.
    ///   - kind: The event's kind.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    func unhideFeedEvent(id: Int, kind: BZKFeedEventKind) async throws {
        try await sendEventReference(path: "feed/events/unhide", reference: BZKFeedEventReference(kind: kind, id: id, idKey: "event_id"))
    }
}

extension BZKManager {
    func signedInUserPath() throws -> String {
        guard token != nil, let userName else { throw BZKClientError.missingToken }
        return "user/\(BZKRequest.segment(userName))"
    }

    func feed(path: String, before: Date?, after: Date?, count: Int) async throws -> [BZKFeedEvent] {
        let request = try BZKRequest(
            path: "\(signedInUserPath())/\(path)",
            queryItems: BZKRequest.query([
                "max_ts": before.map { String(Int($0.timeIntervalSince1970)) },
                "min_ts": after.map { String(Int($0.timeIntervalSince1970)) },
                "count": String(count)
            ])
        )
        let response: BZKPayloadResponse<BZKFeedEventList> = try await perform(request)
        return response.payload.events
    }

    func createEvent(path: String, metadata: BZKRecommendationEventMetadata) async throws -> Int {
        let request = try BZKRequest(
            method: .post,
            path: "\(signedInUserPath())/\(path)",
            body: encode(BZKRecommendationEventBody(metadata: metadata))
        )
        let response: BZKCreatedEvent = try await perform(request)
        return response.id
    }

    func sendEventReference(path: String, reference: BZKFeedEventReference) async throws {
        let request = try BZKRequest(method: .post, path: "\(signedInUserPath())/\(path)", body: encode(reference))
        try await send(request)
    }
}
