//
//  BZKEraActivity.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The number of listens to music released in one year.
public struct BZKEraActivity: Sendable, Hashable, Decodable {
    /// The release year.
    public let year: Int
    /// The number of listens.
    public let listenCount: Int

    enum CodingKeys: String, CodingKey {
        case year
        case listenCount = "listen_count"
    }
}
