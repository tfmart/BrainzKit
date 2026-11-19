//
//  BZKPinBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPinBody: Encodable {
    let recordingMBID: String?
    let recordingMSID: String?
    let blurb: String?
    let pinnedUntil: Int?

    enum CodingKeys: String, CodingKey {
        case recordingMBID = "recording_mbid"
        case recordingMSID = "recording_msid"
        case blurb = "blurb_content"
        case pinnedUntil = "pinned_until"
    }

    init(recording: BZKRecordingIdentifier, blurb: String?, pinnedUntil: Date?) {
        switch recording {
        case .mbid(let mbid):
            recordingMBID = mbid
            recordingMSID = nil
        case .msid(let msid):
            recordingMBID = nil
            recordingMSID = msid
        }
        self.blurb = blurb
        self.pinnedUntil = pinnedUntil.map { Int($0.timeIntervalSince1970) }
    }
}
