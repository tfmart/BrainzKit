//
//  BZKManager+Status.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Fetches information about a ListenBrainz data dump.
    ///
    /// Dumps can be downloaded from [data.metabrainz.org](https://data.metabrainz.org/pub/musicbrainz/listenbrainz/).
    ///
    /// - Parameter id: The dump's ID. When `nil`, the latest dump is returned.
    /// - Returns: The dump.
    /// - Throws: ``BZKError`` with status 404 if no dump has that ID.
    func dump(id: Int? = nil) async throws -> BZKDump {
        let request = BZKRequest(path: "status/get-dump-info", queryItems: BZKRequest.query(["id": id.map(String.init)]))
        return try await perform(request)
    }

    /// Fetches how up to date ListenBrainz's listens, statistics, and dumps are.
    ///
    /// - Returns: The service status.
    func serviceStatus() async throws -> BZKServiceStatus {
        try await perform(BZKRequest(path: "status/service-status"))
    }

    /// Fetches how long ago each kind of generated playlist, such as Daily Jams, was last created.
    ///
    /// - Returns: One entry per playlist kind.
    func generatedPlaylistStatus() async throws -> [BZKDataAge] {
        let response: BZKPlaylistStatusResponse = try await perform(BZKRequest(path: "status/playlist-status"))
        return response.playlists
    }

    /// Fetches the most recent donors.
    ///
    /// - Parameters:
    ///   - count: The number of donors to return.
    ///   - offset: The number of donors to skip.
    /// - Returns: Donors, most recent first.
    func recentDonors(count: Int = 25, offset: Int = 0) async throws -> [BZKDonor] {
        try await perform(BZKRequest(path: "donors/recent", queryItems: BZKRequest.query(["count": String(count), "offset": String(offset)])))
    }

    /// Fetches the biggest donors.
    ///
    /// - Parameters:
    ///   - count: The number of donors to return.
    ///   - offset: The number of donors to skip.
    /// - Returns: Donors, biggest donation first.
    func biggestDonors(count: Int = 25, offset: Int = 0) async throws -> [BZKDonor] {
        try await perform(BZKRequest(path: "donors/biggest", queryItems: BZKRequest.query(["count": String(count), "offset": String(offset)])))
    }

    /// Fetches the flair of every user who has one.
    ///
    /// - Returns: Each user's flair, keyed by user name.
    func donorFlairs() async throws -> [String: BZKFlair] {
        let response: [String: String?] = try await perform(BZKRequest(path: "donors/all-flairs"))
        return response.compactMapValues { $0.flatMap(BZKFlair.init(rawValue:)) }
    }
}
