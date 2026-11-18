//
//  BZKManager+Statistics.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Fetches the most listened artists.
    ///
    /// - Parameters:
    ///   - scope: A user or the whole site.
    ///   - range: The time range to rank over.
    ///   - count: The number of artists to return.
    ///   - offset: The number of artists to skip.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has not calculated these statistics yet.
    func topArtists(
        for scope: BZKStatisticsScope,
        range: BZKStatisticsRange = .allTime,
        count: Int = 25,
        offset: Int = 0
    ) async throws -> BZKStatisticsPage<BZKArtistStatistic> {
        try await top(for: scope, range: range, count: count, offset: offset)
    }

    /// Fetches the most listened releases.
    ///
    /// - Parameters:
    ///   - scope: A user or the whole site.
    ///   - range: The time range to rank over.
    ///   - count: The number of releases to return.
    ///   - offset: The number of releases to skip.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has not calculated these statistics yet.
    func topReleases(
        for scope: BZKStatisticsScope,
        range: BZKStatisticsRange = .allTime,
        count: Int = 25,
        offset: Int = 0
    ) async throws -> BZKStatisticsPage<BZKReleaseStatistic> {
        try await top(for: scope, range: range, count: count, offset: offset)
    }

    /// Fetches the most listened release groups, such as albums.
    ///
    /// - Parameters:
    ///   - scope: A user or the whole site.
    ///   - range: The time range to rank over.
    ///   - count: The number of release groups to return.
    ///   - offset: The number of release groups to skip.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has not calculated these statistics yet.
    func topReleaseGroups(
        for scope: BZKStatisticsScope,
        range: BZKStatisticsRange = .allTime,
        count: Int = 25,
        offset: Int = 0
    ) async throws -> BZKStatisticsPage<BZKReleaseGroupStatistic> {
        try await top(for: scope, range: range, count: count, offset: offset)
    }

    /// Fetches the most listened recordings.
    ///
    /// - Parameters:
    ///   - scope: A user or the whole site.
    ///   - range: The time range to rank over.
    ///   - count: The number of recordings to return.
    ///   - offset: The number of recordings to skip.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has not calculated these statistics yet.
    func topRecordings(
        for scope: BZKStatisticsScope,
        range: BZKStatisticsRange = .allTime,
        count: Int = 25,
        offset: Int = 0
    ) async throws -> BZKStatisticsPage<BZKRecordingStatistic> {
        try await top(for: scope, range: range, count: count, offset: offset)
    }

    /// Fetches how many listens happened in each period of a range.
    ///
    /// - Parameters:
    ///   - scope: A user or the whole site.
    ///   - range: The time range to chart.
    /// - Returns: One entry per period, in chronological order.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has not calculated these statistics yet.
    func listeningActivity(
        for scope: BZKStatisticsScope,
        range: BZKStatisticsRange = .allTime
    ) async throws -> [BZKListeningActivity] {
        let request = BZKRequest(
            path: "\(scope.path)/listening-activity",
            queryItems: BZKRequest.query(["range": range.rawValue])
        )
        let response: BZKPayloadResponse<BZKListeningActivityPayload> = try await perform(request)
        return response.payload.listeningActivity
    }
}

extension BZKManager {
    func top<Entity: BZKStatisticsEntity>(
        for scope: BZKStatisticsScope,
        range: BZKStatisticsRange,
        count: Int,
        offset: Int
    ) async throws -> BZKStatisticsPage<Entity> {
        let request = BZKRequest(
            path: "\(scope.path)/\(Entity.endpoint)",
            queryItems: BZKRequest.query([
                "range": range.rawValue,
                "count": String(count),
                "offset": String(offset)
            ])
        )
        let response: BZKPayloadResponse<BZKStatisticsPage<Entity>> = try await perform(request)
        return response.payload
    }
}
