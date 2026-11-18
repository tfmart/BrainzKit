//
//  BZKDeleteListenBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKDeleteListenBody: Encodable {
    let listenedAt: Int
    let recordingMSID: String

    enum CodingKeys: String, CodingKey {
        case listenedAt = "listened_at"
        case recordingMSID = "recording_msid"
    }
}
