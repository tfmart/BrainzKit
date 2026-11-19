//
//  BZKReviewEventMetadata.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKReviewEventMetadata: Encodable {
    let entityName: String
    let entityID: String
    let entityType: String
    let text: String
    let language: String
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case entityName = "entity_name"
        case entityID = "entity_id"
        case entityType = "entity_type"
        case text
        case language
        case rating
    }
}
