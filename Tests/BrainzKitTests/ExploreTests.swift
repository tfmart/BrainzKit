//
//  ExploreTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct ExploreTests {
    @Test func artistRadioListsSeedArtistFirst() async throws {
        let server = FakeListenBrainz(body: """
        {
          "e3b3de77-0e3f-4c51-b4f5-b99d6df42c66": [{"recording_mbid": "r2", "similar_artist_mbid": "e3b3de77-0e3f-4c51-b4f5-b99d6df42c66", "similar_artist_name": "Beth Hirsch", "total_listen_count": 10}],
          "cb67438a-7f50-4f2b-a6f1-2bb2729fd538": [{"recording_mbid": "r1", "similar_artist_mbid": "cb67438a-7f50-4f2b-a6f1-2bb2729fd538", "similar_artist_name": "Air", "total_listen_count": 20}],
          "056e4f3e-d505-4dad-8ec1-d04f521cbb56": [{"recording_mbid": "r3", "similar_artist_mbid": "056e4f3e-d505-4dad-8ec1-d04f521cbb56", "similar_artist_name": "Daft Punk", "total_listen_count": 30}]
        }
        """)

        let recordings = try await server.manager(signedIn: false).radioRecordings(forArtist: "cb67438a-7f50-4f2b-a6f1-2bb2729fd538")

        #expect(recordings.map(\.artistName) == ["Air", "Beth Hirsch", "Daft Punk"])
    }

    @Test func tagRadioRequiringAllTagsSendsEachTag() async throws {
        let server = FakeListenBrainz(body: "[]")

        _ = try await server.manager(signedIn: false).radioRecordings(forTags: ["trip hop", "downtempo"], matchAll: true)

        let url = try #require(try await server.lastRequest().url)
        let items = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems)
        #expect(items.filter { $0.name == "tag" }.map(\.value) == ["trip hop", "downtempo"])
        #expect(items.first { $0.name == "operator" }?.value == "AND")
    }

    @Test func radioPlaylistsAreUsableWithoutBeingSaved() async throws {
        let server = FakeListenBrainz(body: """
        {
          "payload": {
            "feedback": ["Using seed artist Air"],
            "jspf": {
              "playlist": {
                "title": "LB Radio for artist Air on easy mode",
                "creator": "ListenBrainz Troi",
                "track": [{"title": "All I Need", "creator": "Air", "identifier": ["https://musicbrainz.org/recording/e9759a5a-5efc-4030-8168-f08790ae4ddc"]}]
              }
            }
          }
        }
        """)

        let radio = try await server.manager().radio(prompt: "artist:(Air)")

        #expect(radio.tracks.map(\.recordingMBID) == ["e9759a5a-5efc-4030-8168-f08790ae4ddc"])
        #expect(radio.notes == ["Using seed artist Air"])
    }
}
