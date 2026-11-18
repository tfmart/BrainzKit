//
//  BZKManager+ListenHistory.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Fetches a user's recent listens, newest first.
    ///
    /// Pass either `before` or `after`, not both. To page back through history, pass the oldest returned ``BZKListen/listenedAt`` as `before`.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - before: Only return listens that happened before this date.
    ///   - after: Only return listens that happened after this date.
    ///   - count: The number of listens to return.
    /// - Returns: A batch of listens.
    func listens(
        forUser userName: String,
        before: Date? = nil,
        after: Date? = nil,
        count: Int = 25
    ) async throws -> BZKListens {
        let request = BZKRequest(
            path: "user/\(BZKRequest.segment(userName))/listens",
            queryItems: BZKRequest.query([
                "max_ts": before.map { String(Int($0.timeIntervalSince1970)) },
                "min_ts": after.map { String(Int($0.timeIntervalSince1970)) },
                "count": String(count)
            ])
        )
        let response: BZKPayloadResponse<BZKListens> = try await perform(request)
        return response.payload
    }

    /// Fetches the total number of listens a user has.
    ///
    /// - Parameter userName: The ListenBrainz user name.
    func listenCount(forUser userName: String) async throws -> Int {
        let request = BZKRequest(path: "user/\(BZKRequest.segment(userName))/listen-count")
        let response: BZKPayloadResponse<BZKListenCount> = try await perform(request)
        return response.payload.count
    }

    /// Fetches the track a user is listening to right now.
    ///
    /// - Parameter userName: The ListenBrainz user name.
    /// - Returns: The now playing listen, or `nil` if the user is not listening to anything.
    func playingNow(forUser userName: String) async throws -> BZKListen? {
        let request = BZKRequest(path: "user/\(BZKRequest.segment(userName))/playing-now")
        let response: BZKPayloadResponse<BZKPlayingNowPayload> = try await perform(request)
        return response.payload.listens.first
    }
}
