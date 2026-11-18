//
//  BZKListenType.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

enum BZKListenType: String, Encodable {
    case single
    case playingNow = "playing_now"
    case `import`
}
