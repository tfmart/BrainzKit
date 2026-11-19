//
//  BZKPlaylistExtension.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPlaylistExtension: Decodable {
    let createdFor: String?
    let collaborators: [String]?
    let lastModifiedAt: String?
    let isPublic: Bool?

    enum CodingKeys: String, CodingKey {
        case createdFor = "created_for"
        case collaborators
        case lastModifiedAt = "last_modified_at"
        case isPublic = "public"
    }
}
