//
//  BZKArtistActivityPayload.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKArtistActivityPayload: Decodable {
    let artistActivity: [BZKArtistActivity]

    enum CodingKeys: String, CodingKey {
        case artistActivity = "artist_activity"
    }
}
