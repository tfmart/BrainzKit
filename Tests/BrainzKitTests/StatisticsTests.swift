//
//  StatisticsTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct StatisticsTests {
    @Test func topRecordingsReturnRankedPage() async throws {
        let server = FakeListenBrainz(body: """
        {
          "payload": {
            "count": 1,
            "offset": 0,
            "range": "this_year",
            "from_ts": 1704067200,
            "to_ts": 1735689599,
            "last_updated": 1735600000,
            "total_recording_count": 812,
            "user_id": "rob",
            "recordings": [
              {
                "track_name": "Digital Love",
                "artist_name": "Daft Punk",
                "release_name": "Discovery",
                "recording_mbid": "cccccccc-0000-0000-0000-000000000003",
                "artist_mbids": ["056e4f3e-d505-4dad-8ec1-d04f521cbb56"],
                "listen_count": 42
              }
            ]
          }
        }
        """)

        let page = try await server.manager().topRecordings(for: .user("rob"), range: .thisYear, count: 1)

        #expect(page.totalCount == 812)
        #expect(page.range == .thisYear)
        let recording = try #require(page.items.first)
        #expect(recording.trackName == "Digital Love")
        #expect(recording.listenCount == 42)
        #expect(recording.coverArt == nil)
        #expect(try await server.lastRequest().url?.path == "/1/stats/user/rob/recordings")
    }

    @Test func statisticsNotYetCalculatedReportNoContent() async throws {
        let server = FakeListenBrainz(status: 204, body: "")

        await #expect(throws: BZKClientError.noContent) {
            try await server.manager().topArtists(for: .sitewide, range: .week)
        }
    }
}
