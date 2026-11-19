//
//  BZKFeedbackLookupBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKFeedbackLookupBody: Encodable {
    let recordingMBIDs: [String]
    let recordingMSIDs: [String]

    enum CodingKeys: String, CodingKey {
        case recordingMBIDs = "recording_mbids"
        case recordingMSIDs = "recording_msids"
    }
}
