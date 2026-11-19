//
//  PopularityTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct PopularityTests {
    @Test func releaseGroupPopularityIsMatchedToEachRequestedID() async throws {
        let server = FakeListenBrainz(body: """
        [{"release_group_mbid": "b0bf2b77-b8cf-32f6-8893-9741d757b400", "total_listen_count": 437761, "total_user_count": 17469}]
        """)

        let results = try await server.manager(signedIn: false).popularity(ofReleaseGroups: ["b0bf2b77-b8cf-32f6-8893-9741d757b400"])

        #expect(try await server.lastJSONBody()["release_group_mbids"] as? [String] == ["b0bf2b77-b8cf-32f6-8893-9741d757b400"])
        #expect(results.count == 1)
        #expect(results.first?.mbid == "b0bf2b77-b8cf-32f6-8893-9741d757b400")
        #expect(results.first?.listenCount == 437761)
    }

    @Test func artistTopRecordingsRequireSignIn() async throws {
        let server = FakeListenBrainz(body: "[]")

        await #expect(throws: BZKClientError.missingToken) {
            try await server.manager(signedIn: false).topRecordings(forArtist: "cb67438a-7f50-4f2b-a6f1-2bb2729fd538")
        }
        #expect(await server.log.requests.isEmpty)
    }
}
