//
//  BZKManager+ListeningInsights.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Fetches listens grouped by the country each artist is from, for drawing a map.
    ///
    /// - Parameters:
    ///   - scope: A user or the whole site.
    ///   - range: The time range.
    /// - Returns: One entry per country.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has not calculated these statistics yet.
    func artistCountries(for scope: BZKStatisticsScope, range: BZKStatisticsRange = .allTime) async throws -> [BZKCountryStatistic] {
        let request = BZKRequest(path: "\(scope.path)/artist-map", queryItems: BZKRequest.query(["range": range.rawValue]))
        let response: BZKPayloadResponse<BZKArtistMapPayload> = try await perform(request)
        return response.payload.artistMap
    }

    /// Fetches how many listens a user has in each hour of each weekday, for drawing a heatmap.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - range: The time range.
    /// - Returns: One entry per weekday and hour, ordered from Monday to Sunday and by hour. Hours are in UTC.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has not calculated these statistics yet.
    func hourlyActivity(forUser userName: String, range: BZKStatisticsRange = .allTime) async throws -> [BZKHourlyActivity] {
        let request = BZKRequest(
            path: "stats/user/\(BZKRequest.segment(userName))/daily-activity",
            queryItems: BZKRequest.query(["range": range.rawValue])
        )
        let response: BZKPayloadResponse<BZKDailyActivityPayload> = try await perform(request)
        return response.payload.activity
    }

    /// Fetches a user's Year in Music summary.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - year: The year to summarize.
    /// - Returns: The summary. Fields ListenBrainz didn't calculate for that year are `nil` or empty.
    func yearInMusic(forUser userName: String, year: Int) async throws -> BZKYearInMusic {
        let request = BZKRequest(path: "stats/user/\(BZKRequest.segment(userName))/year-in-music/\(year)")
        let response: BZKPayloadResponse<BZKYearInMusic> = try await perform(request)
        return response.payload
    }

    /// Fetches the users who listened to an artist the most.
    ///
    /// - Parameters:
    ///   - artistMBID: The MusicBrainz artist ID.
    ///   - range: The time range.
    /// - Returns: The top listeners and overall totals.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has not calculated these statistics yet.
    func topListeners(ofArtist artistMBID: String, range: BZKStatisticsRange = .allTime) async throws -> BZKTopListeners {
        try await topListeners(path: "stats/artist/\(BZKRequest.segment(artistMBID))/listeners", range: range)
    }

    /// Fetches the users who listened to an album, single, or other release group the most.
    ///
    /// - Parameters:
    ///   - releaseGroupMBID: The MusicBrainz release group ID.
    ///   - range: The time range.
    /// - Returns: The top listeners and overall totals.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has not calculated these statistics yet.
    func topListeners(ofReleaseGroup releaseGroupMBID: String, range: BZKStatisticsRange = .allTime) async throws -> BZKTopListeners {
        try await topListeners(path: "stats/release-group/\(BZKRequest.segment(releaseGroupMBID))/listeners", range: range)
    }

    /// Fetches how similar two users' listening tastes are.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - otherUserName: The user to compare with.
    /// - Returns: The similarity from 0 to 1, or `nil` if the users aren't similar enough for ListenBrainz to report it.
    func similarity(ofUser userName: String, to otherUserName: String) async throws -> Double? {
        let request = BZKRequest(path: "user/\(BZKRequest.segment(userName))/similar-to/\(BZKRequest.segment(otherUserName))")
        do {
            let response: BZKPayloadResponse<BZKSimilarityPayload> = try await perform(request)
            return response.payload.similarity
        } catch BZKClientError.noContent {
            return nil
        }
    }
}

extension BZKManager {
    func topListeners(path: String, range: BZKStatisticsRange) async throws -> BZKTopListeners {
        let request = BZKRequest(path: path, queryItems: BZKRequest.query(["range": range.rawValue]))
        let response: BZKPayloadResponse<BZKTopListeners> = try await perform(request)
        return response.payload
    }
}
