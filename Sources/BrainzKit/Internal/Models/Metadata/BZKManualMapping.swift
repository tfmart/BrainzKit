//
//  BZKManualMapping.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKManualMapping: Codable {
    let recordingMSID: String
    let recordingMBID: String

    enum CodingKeys: String, CodingKey {
        case recordingMSID = "recording_msid"
        case recordingMBID = "recording_mbid"
    }
}
