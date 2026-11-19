//
//  BZKRecommendationEventMetadata.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKRecommendationEventMetadata: Encodable {
    let recordingMBID: String?
    let recordingMSID: String?
    let users: [String]?
    let blurb: String?

    enum CodingKeys: String, CodingKey {
        case recordingMBID = "recording_mbid"
        case recordingMSID = "recording_msid"
        case users
        case blurb = "blurb_content"
    }

    init(recording: BZKRecordingIdentifier, users: [String]?, blurb: String?) {
        switch recording {
        case .mbid(let mbid):
            recordingMBID = mbid
            recordingMSID = nil
        case .msid(let msid):
            recordingMBID = nil
            recordingMSID = msid
        }
        self.users = users
        self.blurb = blurb
    }
}
