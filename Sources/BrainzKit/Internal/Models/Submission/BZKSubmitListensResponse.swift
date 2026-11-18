//
//  BZKSubmitListensResponse.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKSubmitListensResponse: Decodable {
    let recordingMSID: String?

    enum CodingKeys: String, CodingKey {
        case recordingMSID = "recording_msid"
    }
}
