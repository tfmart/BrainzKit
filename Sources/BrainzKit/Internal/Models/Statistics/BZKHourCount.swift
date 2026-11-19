//
//  BZKHourCount.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKHourCount: Decodable {
    let hour: Int
    let listenCount: Int

    enum CodingKeys: String, CodingKey {
        case hour
        case listenCount = "listen_count"
    }
}
