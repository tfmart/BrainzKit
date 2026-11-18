//
//  MetadataTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct MetadataTests {
    @Test func lookupReturnsMatchedRecording() async throws {
        let server = FakeListenBrainz(body: """
        {
          "artist_credit_name": "Simon & Garfunkel",
          "artist_mbids": ["5d02f264-e225-41ff-83f7-d9b1f0b1874a"],
          "recording_mbid": "dddddddd-0000-0000-0000-000000000004",
          "recording_name": "The Boxer",
          "release_mbid": "eeeeeeee-0000-0000-0000-000000000005",
          "release_name": "Bridge Over Troubled Water"
        }
        """)

        let match = try await server.manager().lookupRecording(artist: "Simon & Garfunkel", track: "The Boxer")

        #expect(match?.recordingMBID == "dddddddd-0000-0000-0000-000000000004")
        #expect(match?.artistCreditName == "Simon & Garfunkel")
    }

    @Test func lookupWithoutMatchReturnsNil() async throws {
        let server = FakeListenBrainz(body: "{}")

        let match = try await server.manager().lookupRecording(artist: "Nobody", track: "Nothing")

        #expect(match == nil)
    }

    @Test func plusSignsInQueryValuesReachListenBrainzIntact() async throws {
        let server = FakeListenBrainz(body: "{}")

        _ = try await server.manager().lookupRecording(artist: "Simon + Garfunkel", track: "A+B")

        let query = try #require(try await server.lastRequest().url?.query)
        #expect(query == "artist_name=Simon%20%2B%20Garfunkel&recording_name=A%2BB")
    }
}
