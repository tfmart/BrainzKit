//
//  BZKFreshReleasesPayload.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKFreshReleasesPayload: Decodable {
    let releases: [BZKFreshRelease]
}
