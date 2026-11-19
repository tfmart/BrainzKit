//
//  BZKFeedbackImportResult.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The outcome of importing loved tracks.
public struct BZKFeedbackImportResult: Sendable, Hashable, Decodable {
    /// The number of loved tracks found on the service, if reported.
    public let total: Int?
    /// The number of tracks that were matched and loved on ListenBrainz, if reported.
    public let imported: Int?
}
