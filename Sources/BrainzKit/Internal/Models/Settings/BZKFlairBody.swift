//
//  BZKFlairBody.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKFlairBody: Encodable {
    let flair: BZKFlair?

    enum CodingKeys: String, CodingKey {
        case flair
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(flair, forKey: .flair)
    }
}
