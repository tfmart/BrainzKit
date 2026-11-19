//
//  BZKThanksMetadata.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKThanksMetadata: Encodable {
    let originalEventType: BZKFeedEventKind
    let originalEventID: Int
    let blurb: String?

    enum CodingKeys: String, CodingKey {
        case originalEventType = "original_event_type"
        case originalEventID = "original_event_id"
        case blurb = "blurb_content"
    }
}
