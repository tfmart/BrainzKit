//
//  BZKFeedbackBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKFeedbackBody: Encodable {
    let recordingMBID: String?
    let recordingMSID: String?
    let score: BZKFeedbackScore

    enum CodingKeys: String, CodingKey {
        case recordingMBID = "recording_mbid"
        case recordingMSID = "recording_msid"
        case score
    }

    init(score: BZKFeedbackScore, recording: BZKRecordingIdentifier) {
        self.score = score
        switch recording {
        case .mbid(let mbid):
            recordingMBID = mbid
            recordingMSID = nil
        case .msid(let msid):
            recordingMBID = nil
            recordingMSID = msid
        }
    }
}
