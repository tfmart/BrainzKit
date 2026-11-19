//
//  BZKPlaylistWriteExtension.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPlaylistWriteExtension: Encodable {
    let isPublic: Bool?
    let collaborators: [String]?

    enum CodingKeys: String, CodingKey {
        case isPublic = "public"
        case collaborators
    }
}
