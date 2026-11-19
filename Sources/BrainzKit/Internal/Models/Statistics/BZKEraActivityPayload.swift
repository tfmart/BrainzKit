//
//  BZKEraActivityPayload.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKEraActivityPayload: Decodable {
    let eraActivity: [BZKEraActivity]

    enum CodingKeys: String, CodingKey {
        case eraActivity = "era_activity"
    }
}
