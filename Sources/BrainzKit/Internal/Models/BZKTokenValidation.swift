//
//  BZKTokenValidation.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKTokenValidation: Decodable {
    let valid: Bool
    let userName: String?

    enum CodingKeys: String, CodingKey {
        case valid
        case userName = "user_name"
    }
}
