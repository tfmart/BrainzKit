//
//  BZKPinnedRecordingResponse.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPinnedRecordingResponse: Decodable {
    let pin: BZKPinnedRecording?

    enum CodingKeys: String, CodingKey {
        case pin = "pinned_recording"
    }
}
