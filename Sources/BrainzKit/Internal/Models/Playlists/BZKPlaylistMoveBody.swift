//
//  BZKPlaylistMoveBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPlaylistMoveBody: Encodable {
    let mbid: String
    let from: Int
    let to: Int
    let count: Int
}
