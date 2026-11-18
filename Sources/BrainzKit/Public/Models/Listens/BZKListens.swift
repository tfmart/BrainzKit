//
//  BZKListens.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A batch of a user's listens, newest first.
public struct BZKListens: Sendable, Hashable, Decodable {
    /// The listens, newest first.
    public let listens: [BZKListen]
    /// The number of listens in this batch.
    public let count: Int
    /// When the user's most recent listen happened.
    public let latestListenDate: Date?
    /// When the user's oldest listen happened.
    public let oldestListenDate: Date?

    enum CodingKeys: String, CodingKey {
        case listens
        case count
        case latestListenDate = "latest_listen_ts"
        case oldestListenDate = "oldest_listen_ts"
    }
}
