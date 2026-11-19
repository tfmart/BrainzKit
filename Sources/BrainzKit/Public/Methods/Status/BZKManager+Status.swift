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
}
