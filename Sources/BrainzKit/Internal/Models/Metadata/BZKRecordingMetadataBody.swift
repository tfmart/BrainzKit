//
//  BZKRecordingMetadataBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKRecordingMetadataBody: Encodable {
    let recordingMBIDs: [String]
    let inc = "artist tag release"

    enum CodingKeys: String, CodingKey {
        case recordingMBIDs = "recording_mbids"
        case inc
    }
}
