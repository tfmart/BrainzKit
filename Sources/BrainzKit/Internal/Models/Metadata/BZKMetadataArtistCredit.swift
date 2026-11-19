//
//  BZKMetadataArtistCredit.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKMetadataArtistCredit: Decodable {
    let name: String
    let artists: [BZKArtistMetadata]?
}
