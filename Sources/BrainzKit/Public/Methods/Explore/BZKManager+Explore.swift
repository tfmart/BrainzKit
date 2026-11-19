//
//  BZKManager+Explore.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Fetches releases that came out recently or are coming soon.
    ///
    /// - Parameters:
    ///   - days: How many days around `date` to include, up to 90.
    ///   - date: The date to center on. When `nil`, today is used.
    ///   - sort: How to order the releases.
    ///   - includePast: Whether to include releases before `date`.
    ///   - includeFuture: Whether to include releases after `date`.
    /// - Returns: The releases.
    /// - Throws: ``BZKError`` with status 400 if `days` is out of range.
    func freshReleases(
        days: Int = 14,
        around date: Date? = nil,
        sort: BZKFreshReleaseSort = .releaseDate,
        includePast: Bool = true,
        includeFuture: Bool = true
    ) async throws -> [BZKFreshRelease] {
        let request = BZKRequest(
            path: "explore/fresh-releases/",
            queryItems: BZKRequest.query([
                "days": String(days),
                "release_date": date.map { $0.formatted(Date.ISO8601FormatStyle().year().month().day()) },
                "sort": sort.rawValue,
                "past": includePast ? "true" : "false",
                "future": includeFuture ? "true" : "false"
            ])
        )
        let response: BZKPayloadResponse<BZKFreshReleasesPayload> = try await perform(request)
        return response.payload.releases
    }

    /// Finds releases whose cover art matches a color.
    ///
    /// - Parameters:
    ///   - hexColor: A six-digit hex color such as "ff8800", without a leading `#`.
    ///   - count: The number of releases to return.
    /// - Returns: Releases, closest color first.
    /// - Throws: ``BZKError`` with status 400 if the color isn't a six-digit hex code.
    func releases(matchingColor hexColor: String, count: Int = 25) async throws -> [BZKColorRelease] {
        let request = BZKRequest(
            path: "explore/color/\(BZKRequest.segment(hexColor))",
            queryItems: BZKRequest.query(["count": String(count)])
        )
        let response: BZKPayloadResponse<BZKColorReleasesPayload> = try await perform(request)
        return response.payload.releases
    }

    /// Generates a playlist with LB Radio from a prompt such as `artist:(Daft Punk)` or `tag:(trip hop)`.
    ///
    /// See the [LB Radio documentation](https://listenbrainz.readthedocs.io/en/latest/general/lb-radio.html) for the prompt syntax. Requires a signed-in user.
    ///
    /// - Parameters:
    ///   - prompt: The LB Radio prompt.
    ///   - mode: How adventurous the playlist should be.
    /// - Returns: The playlist and notes about how the prompt was interpreted.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the prompt is invalid.
    func radio(prompt: String, mode: BZKRadioMode = .easy) async throws -> BZKRadioPlaylist {
        let request = try BZKRequest(
            path: "explore/lb-radio",
            queryItems: BZKRequest.query(["prompt": prompt, "mode": mode.rawValue]),
            token: requiredToken()
        )
        let response: BZKPayloadResponse<BZKRadioPlaylist> = try await perform(request)
        return response.payload
    }

    /// Fetches recordings by an artist and similar artists, as used by LB Radio.
    ///
    /// - Parameters:
    ///   - artistMBID: The MusicBrainz ID of the seed artist.
    ///   - mode: How adventurous the selection should be.
    ///   - maxSimilarArtists: The maximum number of similar artists to include.
    ///   - maxRecordingsPerArtist: The maximum number of recordings per artist.
    ///   - popularity: The popularity percentile range to pick from, where 100 is the most popular.
    /// - Returns: The recordings, grouped by artist: the seed artist first, then similar artists by name.
    func radioRecordings(
        forArtist artistMBID: String,
        mode: BZKRadioMode = .easy,
        maxSimilarArtists: Int = 5,
        maxRecordingsPerArtist: Int = 5,
        popularity: ClosedRange<Int> = 0...100
    ) async throws -> [BZKArtistRadioRecording] {
        let request = BZKRequest(
            path: "lb-radio/artist/\(BZKRequest.segment(artistMBID))",
            queryItems: BZKRequest.query([
                "mode": mode.rawValue,
                "max_similar_artists": String(maxSimilarArtists),
                "max_recordings_per_artist": String(maxRecordingsPerArtist),
                "pop_begin": String(popularity.lowerBound),
                "pop_end": String(popularity.upperBound)
            ])
        )
        let response: [String: [BZKArtistRadioRecording]] = try await perform(request)
        let seed = response[artistMBID] ?? []
        let similar = response
            .filter { $0.key != artistMBID }
            .sorted { ($0.value.first?.artistName ?? "") < ($1.value.first?.artistName ?? "") }
            .flatMap(\.value)
        return seed + similar
    }

    /// Fetches recordings tagged with one or more MusicBrainz tags, as used by LB Radio.
    ///
    /// - Parameters:
    ///   - tags: The tags to match.
    ///   - matchAll: When `true`, recordings must have every tag. When `false`, any tag matches.
    ///   - popularity: The popularity percentile range to pick from, where 100 is the most popular.
    ///   - count: The number of recordings to return.
    /// - Returns: The recordings.
    func radioRecordings(
        forTags tags: [String],
        matchAll: Bool = false,
        popularity: ClosedRange<Int> = 0...100,
        count: Int = 25
    ) async throws -> [BZKTagRadioRecording] {
        var queryItems = tags.map { URLQueryItem(name: "tag", value: $0) }
        queryItems += BZKRequest.query([
            "operator": matchAll ? "AND" : "OR",
            "pop_begin": String(popularity.lowerBound),
            "pop_end": String(popularity.upperBound),
            "count": String(count)
        ])
        return try await perform(BZKRequest(path: "lb-radio/tags", queryItems: queryItems))
    }
}
