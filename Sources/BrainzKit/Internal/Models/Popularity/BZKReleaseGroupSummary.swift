//
//  BZKReleaseGroupSummary.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKReleaseGroupSummary: Decodable {
    let name: String
    let type: String?
    let date: String?
    let caaID: Int?
    let caaReleaseMBID: String?

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case date
        case caaID = "caa_id"
        case caaReleaseMBID = "caa_release_mbid"
    }
}
