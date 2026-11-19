//
//  BZKArtistEvolutionPayload.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKArtistEvolutionPayload: Decodable {
    let artistEvolution: [BZKArtistEvolution]

    enum CodingKeys: String, CodingKey {
        case artistEvolution = "artist_evolution_activity"
    }
}
