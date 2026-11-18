//
//  BZKUserSearchResult.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKUserSearchResult: Decodable {
    let userName: String

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
    }
}
