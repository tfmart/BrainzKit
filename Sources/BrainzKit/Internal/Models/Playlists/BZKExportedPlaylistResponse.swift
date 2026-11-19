//
//  BZKExportedPlaylistResponse.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKExportedPlaylistResponse: Decodable {
    let externalURL: URL

    enum CodingKeys: String, CodingKey {
        case externalURL = "external_url"
    }
}
