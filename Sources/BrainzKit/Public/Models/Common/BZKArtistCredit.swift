//
//  BZKArtistCredit.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// One artist in a recording's artist credit.
public struct BZKArtistCredit: Sendable, Hashable, Decodable {
    /// The artist name as credited.
    public let name: String
    /// The MusicBrainz artist ID, if known.
    public let artistMBID: String?
    /// The text joining this artist to the next, such as " & " or " feat. ".
    public let joinPhrase: String?

    enum CodingKeys: String, CodingKey {
        case name = "artist_credit_name"
        case artistMBID = "artist_mbid"
        case joinPhrase = "join_phrase"
    }
}
