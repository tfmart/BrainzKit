//
//  BZKPlaylistCreatedResponse.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPlaylistCreatedResponse: Decodable {
    let playlistMBID: String

    enum CodingKeys: String, CodingKey {
        case playlistMBID = "playlist_mbid"
    }
}
