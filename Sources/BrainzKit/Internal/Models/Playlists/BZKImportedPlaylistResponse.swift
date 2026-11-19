//
//  BZKImportedPlaylistResponse.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKImportedPlaylistResponse: Decodable {
    let identifier: String

    var playlistID: String {
        identifier.split(separator: "/").last.map(String.init) ?? identifier
    }
}
