//
//  BZKSimilarUser.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A user with similar listening taste.
public struct BZKSimilarUser: Sendable, Hashable, Decodable {
    /// The user's name.
    public let userName: String
    /// How similar the user's taste is, from 0 to 1.
    public let similarity: Double

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case similarity
    }
}
