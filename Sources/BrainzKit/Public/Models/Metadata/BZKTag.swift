//
//  BZKTag.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A MusicBrainz tag, such as a genre, with how many people applied it.
public struct BZKTag: Sendable, Hashable, Decodable {
    /// The tag name.
    public let name: String
    /// The number of MusicBrainz users who applied the tag.
    public let count: Int
    /// The MusicBrainz genre ID, present when the tag is a recognized genre.
    public let genreMBID: String?

    /// Whether the tag is a recognized MusicBrainz genre.
    public var isGenre: Bool {
        genreMBID != nil
    }

    enum CodingKeys: String, CodingKey {
        case name = "tag"
        case count
        case genreMBID = "genre_mbid"
    }
}
