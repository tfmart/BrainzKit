//
//  BZKArtistMapPayload.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKArtistMapPayload: Decodable {
    let artistMap: [BZKCountryStatistic]

    enum CodingKeys: String, CodingKey {
        case artistMap = "artist_map"
    }
}
