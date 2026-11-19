//
//  BZKArtistMetadata.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// MusicBrainz details about an artist.
public struct BZKArtistMetadata: Sendable, Hashable, Decodable {
    /// The MusicBrainz artist ID.
    public let mbid: String
    /// The artist name.
    public let name: String
    /// The artist type, such as "Person" or "Group", if known.
    public let type: String?
    /// Where the artist is from, if known.
    public let area: String?
    /// The year the artist was born or formed, if known.
    public let beginYear: Int?
    /// The year the artist died or disbanded, if known.
    public let endYear: Int?
    /// The artist's gender, if known and applicable.
    public let gender: String?
    /// Links to the artist's homepage, streaming services, social networks, and more.
    public let links: [BZKLink]
    /// The artist's tags, including genres, most applied first. Empty when the artist appears inside recording or release group metadata.
    public let tags: [BZKTag]

    enum CodingKeys: String, CodingKey {
        case mbid = "artist_mbid"
        case name
        case type
        case area
        case beginYear = "begin_year"
        case endYear = "end_year"
        case gender
        case rels
        case tag
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mbid = try container.decode(String.self, forKey: .mbid)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        area = try container.decodeIfPresent(String.self, forKey: .area)
        beginYear = try container.decodeIfPresent(Int.self, forKey: .beginYear)
        endYear = try container.decodeIfPresent(Int.self, forKey: .endYear)
        gender = try container.decodeIfPresent(String.self, forKey: .gender)
        let rels = (try? container.decodeIfPresent([String: String].self, forKey: .rels)) ?? [:]
        links = rels.compactMap { type, url in URL(string: url).map { BZKLink(type: type, url: $0) } }
            .sorted { $0.type < $1.type }
        tags = (try? container.decodeIfPresent(BZKMetadataTags.self, forKey: .tag))?.artist ?? []
    }
}
