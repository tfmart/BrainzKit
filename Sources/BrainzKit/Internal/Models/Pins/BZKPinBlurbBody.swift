//
//  BZKPinBlurbBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPinBlurbBody: Encodable {
    let blurb: String

    enum CodingKeys: String, CodingKey {
        case blurb = "blurb_content"
    }
}
