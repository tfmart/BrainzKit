//
//  BZKSubmittedListen.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKSubmittedListen: Encodable {
    let listenedAt: Int?
    let trackMetadata: BZKSubmittedTrackMetadata

    enum CodingKeys: String, CodingKey {
        case listenedAt = "listened_at"
        case trackMetadata = "track_metadata"
    }

    init(listen: BZKListenSubmission, includesTimestamp: Bool, clientInfo: BZKClientInfo) {
        listenedAt = includesTimestamp ? Int(listen.listenedAt.timeIntervalSince1970) : nil
        trackMetadata = BZKSubmittedTrackMetadata(listen: listen, clientInfo: clientInfo)
    }
}
