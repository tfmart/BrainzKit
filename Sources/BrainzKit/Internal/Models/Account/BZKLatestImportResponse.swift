//
//  BZKLatestImportResponse.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKLatestImportResponse: Decodable {
    let latestImport: Int

    enum CodingKeys: String, CodingKey {
        case latestImport = "latest_import"
    }
}
