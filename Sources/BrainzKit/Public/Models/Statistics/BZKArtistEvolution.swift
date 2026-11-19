//
//  BZKArtistEvolution.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// An artist's listens in one period, used to chart how listening to artists changes over time.
public struct BZKArtistEvolution: Sendable, Hashable, Decodable {
    /// The artist name.
    public let artistName: String
    /// The MusicBrainz artist ID, if known.
    public let artistMBID: String?
    /// The number of listens in the period.
    public let listenCount: Int
    /// The period's label, such as a weekday, day of the month, month name, or year, depending on the range.
    public let period: String

    enum CodingKeys: String, CodingKey {
        case artistName = "artist_name"
        case artistMBID = "artist_mbid"
        case listenCount = "listen_count"
        case period = "time_unit"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        artistName = try container.decode(String.self, forKey: .artistName)
        artistMBID = try container.decodeIfPresent(String.self, forKey: .artistMBID)
        listenCount = try container.decode(Int.self, forKey: .listenCount)
        if let label = try? container.decode(String.self, forKey: .period) {
            period = label
        } else {
            period = String(try container.decode(Int.self, forKey: .period))
        }
    }
}
