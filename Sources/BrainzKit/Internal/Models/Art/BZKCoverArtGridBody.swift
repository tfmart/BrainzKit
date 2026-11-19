//
//  BZKCoverArtGridBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKCoverArtGridBody: Encodable {
    let releaseMBIDs: [String]
    let dimension: Int
    let layout: Int
    let imageSize: Int
    let background: String
    let skipMissing: Bool
    let showCAA: Bool
    let caption: Bool

    enum CodingKeys: String, CodingKey {
        case releaseMBIDs = "release_mbids"
        case dimension
        case layout
        case imageSize = "image_size"
        case background
        case skipMissing = "skip-missing"
        case showCAA = "show-caa"
        case caption
    }
}
