//
//  BZKPopularity.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// How many listens and listeners an artist, recording, release, or release group has across ListenBrainz.
public struct BZKPopularity: Sendable, Hashable, Decodable {
    /// The MusicBrainz ID of the artist, recording, release, or release group.
    public let mbid: String
    /// The total number of listens, if known.
    public let listenCount: Int?
    /// The number of users who listened, if known.
    public let userCount: Int?

    enum CodingKeys: String, CodingKey {
        case listenCount = "total_listen_count"
        case userCount = "total_user_count"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        listenCount = try container.decodeIfPresent(Int.self, forKey: .listenCount)
        userCount = try container.decodeIfPresent(Int.self, forKey: .userCount)
        let keys = try decoder.container(keyedBy: BZKDynamicCodingKey.self)
        guard let key = keys.allKeys.first(where: { $0.stringValue.hasSuffix("_mbid") }) else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Missing MBID"))
        }
        mbid = try keys.decode(String.self, forKey: key)
    }
}
