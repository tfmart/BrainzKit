//
//  BZKPayloadResponse.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKPayloadResponse<Payload: Decodable>: Decodable {
    let payload: Payload
}
