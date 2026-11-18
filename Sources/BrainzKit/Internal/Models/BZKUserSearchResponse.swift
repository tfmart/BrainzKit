//
//  BZKUserSearchResponse.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKUserSearchResponse: Decodable {
    let users: [BZKUserSearchResult]
}
