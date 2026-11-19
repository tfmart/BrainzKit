//
//  BZKDump.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A ListenBrainz data dump: a downloadable snapshot of public listens and other data.
public struct BZKDump: Sendable, Hashable, Decodable, Identifiable {
    /// The dump's ID.
    public let id: Int
    /// The dump type, such as "full" or "incremental".
    public let type: String
    /// When the dump was created.
    public let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case type = "dump_type"
        case timestamp
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        let timestamp = try container.decodeIfPresent(String.self, forKey: .timestamp)
        createdAt = timestamp.flatMap(Self.date(fromDumpTimestamp:))
    }

    static func date(fromDumpTimestamp timestamp: String) -> Date? {
        let digits = timestamp.filter(\.isNumber)
        guard digits.count == 14, let value = Int(digits) else { return nil }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let components = DateComponents(
            year: value / 10_000_000_000,
            month: value / 100_000_000 % 100,
            day: value / 1_000_000 % 100,
            hour: value / 10_000 % 100,
            minute: value / 100 % 100,
            second: value % 100
        )
        return calendar.date(from: components)
    }
}
