//
//  BZKDataAge.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// How long ago a statistic or generated playlist was last updated.
public struct BZKDataAge: Sendable, Hashable, Decodable {
    /// The statistic or playlist name, such as "artists_this_week" or "daily-jams".
    public let name: String
    /// The time since the last update, in seconds.
    public let age: TimeInterval
}
