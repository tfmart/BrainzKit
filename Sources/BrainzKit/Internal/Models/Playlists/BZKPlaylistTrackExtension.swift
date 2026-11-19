//
//  BZKPlaylistTrackExtension.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPlaylistTrackExtension: Decodable {
    let addedAt: String?
    let addedBy: String?
    let artistIdentifiers: [String]?
    let additionalMetadata: BZKPlaylistTrackMetadata?

    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case addedBy = "added_by"
        case artistIdentifiers = "artist_identifiers"
        case additionalMetadata = "additional_metadata"
    }
}
