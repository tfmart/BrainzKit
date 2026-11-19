//
//  BZKGenreActivityPayload.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKGenreActivityPayload: Decodable {
    let genreActivity: [BZKGenreActivity]

    enum CodingKeys: String, CodingKey {
        case genreActivity = "genre_activity"
    }
}
