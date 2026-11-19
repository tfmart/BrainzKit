//
//  BZKPlaylistTrackMetadata.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPlaylistTrackMetadata: Decodable {
    let artists: [BZKArtistCredit]?
    let caaID: Int?
    let caaReleaseMBID: String?

    enum CodingKeys: String, CodingKey {
        case artists
        case caaID = "caa_id"
        case caaReleaseMBID = "caa_release_mbid"
    }
}
