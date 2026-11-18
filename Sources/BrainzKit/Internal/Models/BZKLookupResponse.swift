//
//  BZKLookupResponse.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKLookupResponse: Decodable {
    let match: BZKRecordingMatch?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: BZKRecordingMatch.CodingKeys.self)
        match = container.contains(.recordingMBID) ? try BZKRecordingMatch(from: decoder) : nil
    }
}
