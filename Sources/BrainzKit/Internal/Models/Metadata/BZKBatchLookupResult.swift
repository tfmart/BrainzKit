//
//  BZKBatchLookupResult.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKBatchLookupResult: Decodable {
    let index: Int
    let match: BZKRecordingMatch?

    enum CodingKeys: String, CodingKey {
        case index
    }

    init(from decoder: any Decoder) throws {
        index = try decoder.container(keyedBy: CodingKeys.self).decode(Int.self, forKey: .index)
        match = try BZKLookupResponse(from: decoder).match
    }
}
