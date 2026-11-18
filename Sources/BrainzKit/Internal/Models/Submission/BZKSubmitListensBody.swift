//
//  BZKSubmitListensBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKSubmitListensBody: Encodable {
    let listenType: BZKListenType
    let payload: [BZKSubmittedListen]

    enum CodingKeys: String, CodingKey {
        case listenType = "listen_type"
        case payload
    }

    init(listenType: BZKListenType, listens: [BZKListenSubmission], clientInfo: BZKClientInfo) {
        self.listenType = listenType
        self.payload = listens.map {
            BZKSubmittedListen(listen: $0, includesTimestamp: listenType != .playingNow, clientInfo: clientInfo)
        }
    }
}
