//
//  BZKFeedbackImportBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKFeedbackImportBody: Encodable {
    let service: String
    let userName: String?

    enum CodingKeys: String, CodingKey {
        case service
        case userName = "user_name"
    }

    init(source: BZKFeedbackImportSource) {
        switch source {
        case .lastFM(let userName):
            service = "lastfm"
            self.userName = userName
        case .libreFM(let userName):
            service = "librefm"
            self.userName = userName
        case .navidrome:
            service = "navidrome"
            userName = nil
        }
    }
}
