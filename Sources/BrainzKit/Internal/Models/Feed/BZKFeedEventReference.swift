//
//  BZKFeedEventReference.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKFeedEventReference: Encodable {
    let kind: BZKFeedEventKind
    let id: Int
    let idKey: String

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: BZKDynamicCodingKey.self)
        try container.encode(kind, forKey: BZKDynamicCodingKey("event_type"))
        try container.encode(id, forKey: BZKDynamicCodingKey(idKey))
    }
}
