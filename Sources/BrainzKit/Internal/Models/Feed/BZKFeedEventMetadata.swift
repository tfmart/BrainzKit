//
//  BZKFeedEventMetadata.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKFeedEventMetadata: Decodable {
    let track: BZKTrackMetadata?
    let blurb: String?
    let users: [String]?
    let follower: String?
    let followed: String?
    let message: String?
    let entityName: String?
    let entityID: String?
    let entityType: String?
    let rating: Int?
    let text: String?
    let reviewMBID: String?
    let thanker: String?
    let thankee: String?

    enum CodingKeys: String, CodingKey {
        case track = "track_metadata"
        case blurb = "blurb_content"
        case users
        case follower = "user_name_0"
        case followed = "user_name_1"
        case message
        case entityName = "entity_name"
        case entityID = "entity_id"
        case entityType = "entity_type"
        case rating
        case text
        case reviewMBID = "review_mbid"
        case thanker = "thanker_username"
        case thankee = "thankee_username"
    }

    func content(for kind: BZKFeedEventKind?) -> BZKFeedEventContent {
        switch kind {
        case .listen:
            return track.map(BZKFeedEventContent.listen) ?? .unknown
        case .recordingRecommendation:
            return track.map(BZKFeedEventContent.recordingRecommendation) ?? .unknown
        case .personalRecommendation:
            return track.map { .personalRecommendation($0, recipients: users ?? [], message: blurb) } ?? .unknown
        case .pin:
            return track.map { .pin($0, message: blurb) } ?? .unknown
        case .follow:
            guard let follower, let followed else { return .unknown }
            return .follow(follower: follower, followed: followed)
        case .notification:
            return message.map { .notification(message: $0) } ?? .unknown
        case .review:
            guard let entityName, let entityID, let entityType, let text, let reviewMBID else { return .unknown }
            return .review(BZKFeedReview(entityName: entityName, entityMBID: entityID, entityType: entityType, rating: rating, text: text, reviewMBID: reviewMBID))
        case .thanks:
            guard let thanker, let thankee else { return .unknown }
            return .thanks(thanker: thanker, thankee: thankee, message: blurb)
        case nil:
            return .unknown
        }
    }
}
