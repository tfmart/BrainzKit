//
//  BZKPlaylistStatusResponse.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPlaylistStatusResponse: Decodable {
    let playlists: [BZKDataAge]
}
