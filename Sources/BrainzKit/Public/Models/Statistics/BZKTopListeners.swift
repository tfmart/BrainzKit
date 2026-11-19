//
//  BZKTopListeners.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The users who listened to an artist or release group the most.
public struct BZKTopListeners: Sendable, Hashable, Decodable {
    /// The top listeners, most listens first.
    public let listeners: [BZKListener]
    /// The total number of listens from all users.
    public let totalListenCount: Int
    /// The total number of users who listened.
    public let totalUserCount: Int

    enum CodingKeys: String, CodingKey {
        case listeners
        case totalListenCount = "total_listen_count"
        case totalUserCount = "total_user_count"
    }
}
