//
//  BZKCountryStatistic.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// Listens to artists from one country.
public struct BZKCountryStatistic: Sendable, Hashable, Decodable {
    /// The country's ISO 3166-1 alpha-3 code, such as "FRA" or "USA".
    public let countryCode: String
    /// The number of artists from the country.
    public let artistCount: Int
    /// The number of listens to artists from the country.
    public let listenCount: Int
    /// The artists from the country, most listened first.
    public let artists: [BZKArtistStatistic]

    enum CodingKeys: String, CodingKey {
        case countryCode = "country"
        case artistCount = "artist_count"
        case listenCount = "listen_count"
        case artists
    }
}
