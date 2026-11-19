//
//  BZKListener.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A user and how many times they listened to an artist or release group.
public struct BZKListener: Sendable, Hashable, Decodable {
    /// The ListenBrainz user name.
    public let userName: String
    /// The number of listens.
    public let listenCount: Int

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case listenCount = "listen_count"
    }
}
