//
//  BZKRecommendationFeedbackBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKRecommendationFeedbackBody: Encodable {
    let recordingMBID: String
    let rating: BZKRecommendationRating?

    enum CodingKeys: String, CodingKey {
        case recordingMBID = "recording_mbid"
        case rating
    }
}
