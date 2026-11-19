//
//  BZKServiceStatus.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// How up to date ListenBrainz's data is.
public struct BZKServiceStatus: Sendable, Hashable, Decodable {
    /// The number of submitted listens waiting to be stored.
    public let incomingListenCount: Int?
    /// The time since the last data dump, in seconds.
    public let dumpAge: TimeInterval?
    /// The time since user statistics were last updated, in seconds.
    public let statisticsAge: TimeInterval?
    /// The time since sitewide statistics were last updated, in seconds.
    public let sitewideStatisticsAge: TimeInterval?
    /// The age of each kind of statistic.
    public let statistics: [BZKDataAge]

    enum CodingKeys: String, CodingKey {
        case incomingListenCount = "incoming_listen_count"
        case dumpAge = "dump_age"
        case statisticsAge = "stats_age"
        case sitewideStatisticsAge = "sitewide_stats_age"
        case statistics = "stats"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        incomingListenCount = try container.decodeIfPresent(Int.self, forKey: .incomingListenCount)
        dumpAge = try container.decodeIfPresent(TimeInterval.self, forKey: .dumpAge)
        statisticsAge = try container.decodeIfPresent(TimeInterval.self, forKey: .statisticsAge)
        sitewideStatisticsAge = try container.decodeIfPresent(TimeInterval.self, forKey: .sitewideStatisticsAge)
        statistics = try container.decodeIfPresent([BZKDataAge].self, forKey: .statistics) ?? []
    }
}
