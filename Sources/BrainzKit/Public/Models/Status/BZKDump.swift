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
        let digits = Array(timestamp.filter(\.isNumber))
        guard digits.count == 14 else { return nil }
        func number(_ range: Range<Int>) -> Int? { Int(String(digits[range])) }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let components = DateComponents(
            year: number(0..<4),
            month: number(4..<6),
            day: number(6..<8),
            hour: number(8..<10),
            minute: number(10..<12),
            second: number(12..<14)
        )
        return calendar.date(from: components)
    }
}
