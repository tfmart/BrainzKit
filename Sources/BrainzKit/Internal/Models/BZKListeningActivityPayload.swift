//
//  BZKListeningActivityPayload.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKListeningActivityPayload: Decodable {
    let listeningActivity: [BZKListeningActivity]

    enum CodingKeys: String, CodingKey {
        case listeningActivity = "listening_activity"
    }
}
