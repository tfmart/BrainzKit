//
//  BZKPlaylistRemoveBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPlaylistRemoveBody: Encodable {
    let index: Int
    let count: Int
}
