//
//  BZKPlaylistWriteTrack.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPlaylistWriteTrack: Encodable {
    let identifier: [String]

    init(recordingMBID: String) {
        identifier = ["https://musicbrainz.org/recording/\(recordingMBID)"]
    }
}
