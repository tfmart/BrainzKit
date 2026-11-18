//
//  BZKRequest.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKRequest {
    var method: BZKHTTPMethod = .get
    var path: String
    var queryItems: [URLQueryItem] = []
    var body: Data?
    var token: String?

    static func query(_ pairs: KeyValuePairs<String, String?>) -> [URLQueryItem] {
        pairs.compactMap { name, value in
            value.map { URLQueryItem(name: name, value: $0) }
        }
    }

    static func segment(_ value: String) -> String {
        var allowed = CharacterSet.urlPathAllowed
        allowed.remove("/")
        return value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
    }
}
