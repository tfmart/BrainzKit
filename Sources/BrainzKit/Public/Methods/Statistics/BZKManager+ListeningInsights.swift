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
    ///   - year: The year to summarize. When `nil`, the latest Year in Music is returned.
    /// - Returns: The summary. Fields ListenBrainz didn't calculate for that year are `nil` or empty.
    func yearInMusic(forUser userName: String, year: Int? = nil) async throws -> BZKYearInMusic {
        let path = "stats/user/\(BZKRequest.segment(userName))/year-in-music" + (year.map { "/\($0)" } ?? "")
        let response: BZKPayloadResponse<BZKYearInMusic> = try await perform(BZKRequest(path: path))
        return response.payload
    }

    /// Fetches a Year in Music summary as it was originally published, for 2021 through 2024.
    ///
    /// These archived summaries have release-level top lists instead of release groups, so ``BZKYearInMusic/topReleaseGroups`` is empty.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - year: The year to summarize, from 2021 to 2024.
    /// - Returns: The archived summary.
    func archivedYearInMusic(forUser userName: String, year: Int) async throws -> BZKYearInMusic {
        let request = BZKRequest(path: "stats/user/\(BZKRequest.segment(userName))/year-in-music/legacy/\(year)")
        let response: BZKPayloadResponse<BZKYearInMusic> = try await perform(request)
        return response.payload
    }

    /// Fetches the most listened artists with their listens broken down by album.
    ///
    /// - Parameters:
    ///   - scope: A user or the whole site.
    ///   - range: The time range.
    /// - Returns: Artists, most listened first.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has not calculated these statistics yet.
    func artistActivity(for scope: BZKStatisticsScope, range: BZKStatisticsRange = .allTime) async throws -> [BZKArtistActivity] {
        let response: BZKPayloadResponse<BZKArtistActivityPayload> = try await perform(statisticsRequest(scope, "artist-activity", range))
        return response.payload.artistActivity.sorted { $0.listenCount > $1.listenCount }
    }

    /// Fetches listens per artist per period, for charting how listening to artists changes over time.
    ///
    /// - Parameters:
    ///   - scope: A user or the whole site.
    ///   - range: The time range. It decides the periods: weekdays for a week, days for a month, months for a year, and years for all time.
    /// - Returns: One entry per artist and period.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has not calculated these statistics yet.
    func artistEvolution(for scope: BZKStatisticsScope, range: BZKStatisticsRange = .allTime) async throws -> [BZKArtistEvolution] {
        let response: BZKPayloadResponse<BZKArtistEvolutionPayload> = try await perform(statisticsRequest(scope, "artist-evolution-activity", range))
        return response.payload.artistEvolution
    }

    /// Fetches how many listens went to music released in each year.
    ///
    /// - Parameters:
    ///   - scope: A user or the whole site.
    ///   - range: The time range.
    /// - Returns: One entry per release year, oldest first.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has not calculated these statistics yet.
    func eraActivity(for scope: BZKStatisticsScope, range: BZKStatisticsRange = .allTime) async throws -> [BZKEraActivity] {
        let response: BZKPayloadResponse<BZKEraActivityPayload> = try await perform(statisticsRequest(scope, "era-activity", range))
        return response.payload.eraActivity.sorted { $0.year < $1.year }
    }

    /// Fetches how many listens a user has for each genre in each hour of the day.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - range: The time range.
    /// - Returns: One entry per genre and hour. Hours are in UTC.
    /// - Throws: ``BZKClientError/noContent`` if ListenBrainz has not calculated these statistics yet.
    func genreActivity(forUser userName: String, range: BZKStatisticsRange = .allTime) async throws -> [BZKGenreActivity] {
        let response: BZKPayloadResponse<BZKGenreActivityPayload> = try await perform(statisticsRequest(.user(userName), "genre-activity", range))
        return response.payload.genreActivity
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
    func statisticsRequest(_ scope: BZKStatisticsScope, _ endpoint: String, _ range: BZKStatisticsRange) -> BZKRequest {
        BZKRequest(path: "\(scope.path)/\(endpoint)", queryItems: BZKRequest.query(["range": range.rawValue]))
    }

    func topListeners(path: String, range: BZKStatisticsRange) async throws -> BZKTopListeners {
        let request = BZKRequest(path: path, queryItems: BZKRequest.query(["range": range.rawValue]))
        let response: BZKPayloadResponse<BZKTopListeners> = try await perform(request)
        return response.payload
    }
}
