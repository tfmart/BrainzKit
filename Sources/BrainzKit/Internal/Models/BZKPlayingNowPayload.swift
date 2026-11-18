//
//  BZKPlayingNowPayload.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPlayingNowPayload: Decodable {
    let listens: [BZKListen]
}
