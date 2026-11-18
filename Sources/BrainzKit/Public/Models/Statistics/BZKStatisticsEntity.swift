//
//  BZKStatisticsEntity.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// An entity ListenBrainz ranks in its top statistics.
///
/// BrainzKit provides ``BZKArtistStatistic``, ``BZKReleaseStatistic``, ``BZKReleaseGroupStatistic``, and ``BZKRecordingStatistic``.
public protocol BZKStatisticsEntity: Sendable, Decodable {
    /// The endpoint name for this entity.
    static var endpoint: String { get }
    /// The JSON key holding the list of entities.
    static var itemsKey: String { get }
    /// The JSON key holding the total number of entities.
    static var totalCountKey: String { get }
}
