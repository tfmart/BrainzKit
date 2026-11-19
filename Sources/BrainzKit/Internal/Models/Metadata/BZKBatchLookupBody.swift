//
//  BZKBatchLookupBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKBatchLookupBody: Encodable {
    let recordings: [BZKRecordingQuery]
}
