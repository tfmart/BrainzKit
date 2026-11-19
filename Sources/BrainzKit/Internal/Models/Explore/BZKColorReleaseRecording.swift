//
//  BZKColorReleaseRecording.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKColorReleaseRecording: Decodable {
    let track: BZKTrackMetadata

    enum CodingKeys: String, CodingKey {
        case track = "track_metadata"
    }
}
