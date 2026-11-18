//
//  BZKListeningActivity.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The number of listens in one period of a listening activity chart.
public struct BZKListeningActivity: Sendable, Hashable, Decodable {
    /// A display name for the period, such as a month or a weekday.
    public let timeRange: String
    /// The start of the period.
    public let from: Date
    /// The end of the period.
    public let to: Date
    /// The number of listens in the period.
    public let listenCount: Int

    enum CodingKeys: String, CodingKey {
        case timeRange = "time_range"
        case from = "from_ts"
        case to = "to_ts"
        case listenCount = "listen_count"
    }
}
