//
//  ListenHistoryTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct ListenHistoryTests {
    @Test func listensDecodeWhenClientsSendUnexpectedValueTypes() async throws {
        let server = FakeListenBrainz(body: """
        {
          "payload": {
            "count": 1,
            "latest_listen_ts": 1700000300,
            "oldest_listen_ts": 1500000000,
            "user_id": "rob",
            "listens": [
              {
                "inserted_at": 1700000301,
                "listened_at": 1700000300,
                "recording_msid": "aaaaaaaa-0000-0000-0000-000000000001",
                "user_name": "rob",
                "track_metadata": {
                  "artist_name": "Rick Astley",
                  "track_name": "Never Gonna Give You Up",
                  "release_name": "Whenever You Need Somebody",
                  "additional_info": {
                    "duration_ms": 222000,
                    "tracknumber": "3",
                    "tags": "pop",
                    "submission_client": "Some Scrobbler"
                  },
                  "mbid_mapping": {
                    "recording_mbid": "98255a8c-017a-4bc7-8dd6-1fa36124572b",
                    "caa_id": 12345,
                    "caa_release_mbid": "bbbbbbbb-0000-0000-0000-000000000002",
                    "artists": [{"artist_credit_name": "Rick Astley", "artist_mbid": "db92a151-1ac2-438b-bc43-b82e149ddd50", "join_phrase": ""}]
                  }
                }
              }
            ]
          }
        }
        """)

        let result = try await server.manager().listens(forUser: "rob", before: Date(timeIntervalSince1970: 1_800_000_000), count: 10)

        let listen = try #require(result.listens.first)
        #expect(listen.listenedAt == Date(timeIntervalSince1970: 1_700_000_300))
        #expect(listen.isPlayingNow == false)
        #expect(listen.track.trackName == "Never Gonna Give You Up")
        #expect(listen.track.additionalInfo?.duration == 222)
        #expect(listen.track.additionalInfo?.submissionClient == "Some Scrobbler")
        #expect(listen.track.additionalInfo?.tags == nil)
        #expect(listen.track.mbidMapping?.coverArt?.url(size: 250)?.absoluteString
                == "https://coverartarchive.org/release/bbbbbbbb-0000-0000-0000-000000000002/12345-250.jpg")
        #expect(try await server.lastRequest().url?.query == "max_ts=1800000000&count=10")
    }
}
