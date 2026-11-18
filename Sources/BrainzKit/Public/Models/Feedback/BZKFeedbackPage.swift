//
//  BZKFeedbackPage.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A page of a user's recording feedback.
public struct BZKFeedbackPage: Sendable, Hashable, Decodable {
    /// The feedback on this page.
    public let feedback: [BZKFeedback]
    /// The number of items on this page.
    public let count: Int
    /// The offset of this page.
    public let offset: Int
    /// The total number of feedback items matching the request.
    public let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case feedback
        case count
        case offset
        case totalCount = "total_count"
    }
}
