//
//  BZKStatisticsScope.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// Whose listens statistics are calculated from.
public enum BZKStatisticsScope: Sendable, Hashable {
    /// A single user's listens.
    case user(String)
    /// Every ListenBrainz user's listens.
    case sitewide

    var path: String {
        switch self {
        case .user(let userName): return "stats/user/\(BZKRequest.segment(userName))"
        case .sitewide: return "stats/sitewide"
        }
    }
}
