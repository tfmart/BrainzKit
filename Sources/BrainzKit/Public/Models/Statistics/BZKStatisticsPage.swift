//
//  BZKStatisticsPage.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A page of top statistics.
public struct BZKStatisticsPage<Entity: BZKStatisticsEntity>: Sendable, Decodable {
    /// The ranked entities on this page, most listened first.
    public let items: [Entity]
    /// The number of entities on this page.
    public let count: Int
    /// The offset of this page.
    public let offset: Int
    /// The total number of ranked entities.
    public let totalCount: Int
    /// The range the statistics cover.
    public let range: BZKStatisticsRange?
    /// The start of the period the statistics cover.
    public let from: Date?
    /// The end of the period the statistics cover.
    public let to: Date?
    /// When ListenBrainz last calculated the statistics.
    public let lastUpdated: Date?

    /// Creates a page by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: BZKDynamicCodingKey.self)
        items = try container.decode([Entity].self, forKey: BZKDynamicCodingKey(Entity.itemsKey))
        count = try container.decodeIfPresent(Int.self, forKey: BZKDynamicCodingKey("count")) ?? items.count
        offset = try container.decodeIfPresent(Int.self, forKey: BZKDynamicCodingKey("offset")) ?? 0
        totalCount = try container.decodeIfPresent(Int.self, forKey: BZKDynamicCodingKey(Entity.totalCountKey)) ?? items.count
        range = try? container.decodeIfPresent(BZKStatisticsRange.self, forKey: BZKDynamicCodingKey("range"))
        from = try container.decodeIfPresent(Date.self, forKey: BZKDynamicCodingKey("from_ts"))
        to = try container.decodeIfPresent(Date.self, forKey: BZKDynamicCodingKey("to_ts"))
        lastUpdated = try container.decodeIfPresent(Date.self, forKey: BZKDynamicCodingKey("last_updated"))
    }
}
