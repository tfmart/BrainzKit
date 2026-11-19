//
//  BZKPinnedRecordingList.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPinnedRecordingList: Decodable {
    let pins: [BZKPinnedRecording]

    enum CodingKeys: String, CodingKey {
        case pins = "pinned_recordings"
    }
}
