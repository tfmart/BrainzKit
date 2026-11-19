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

    @Test func recordingMetadataIsKeyedByRecordingWithRankedTagsAndLinks() async throws {
        let server = FakeListenBrainz(body: """
        {
          "738920d3-c6e6-41c7-b504-57761bb625fd": {
            "recording": {
              "name": "Sexy Boy",
              "length": 298466,
              "first_release_date": "1998-01-16",
              "isrcs": ["FRS639700560"],
              "url_rels": [{"type": "streaming", "url": "https://tidal.com/track/1477892"}]
            },
            "artist": {
              "name": "Air",
              "artists": [{"artist_mbid": "cb67438a-7f50-4f2b-a6f1-2bb2729fd538", "name": "Air", "type": "Group", "rels": {"wikidata": "https://www.wikidata.org/wiki/Q318452"}}]
            },
            "release": {"name": "Moon Safari", "mbid": "4c55906c-349b-362d-922e-956762912b42", "year": 1998, "caa_id": 1257682386, "caa_release_mbid": "4c55906c-349b-362d-922e-956762912b42"},
            "tag": {
              "recording": [{"tag": "mellow", "count": 1}, {"tag": "ambient", "count": 3, "genre_mbid": "608b0471-7531-4854-a348-e698c69cb699"}],
              "artist": [{"tag": "electronica", "count": 6, "genre_mbid": "53a3cea3-17af-4421-a07a-5824b540aeb5"}]
            }
          }
        }
        """)

        let metadata = try await server.manager(signedIn: false).recordingMetadata(for: ["738920d3-c6e6-41c7-b504-57761bb625fd"])

        let recording = try #require(metadata["738920d3-c6e6-41c7-b504-57761bb625fd"])
        #expect(recording.duration == 298.466)
        #expect(recording.tags.map(\.name) == ["ambient", "mellow"])
        #expect(recording.tags.filter(\.isGenre).map(\.name) == ["ambient"])
        #expect(recording.artistTags.map(\.name) == ["electronica"])
        #expect(recording.links == [BZKLink(type: "streaming", url: try #require(URL(string: "https://tidal.com/track/1477892")))])
        #expect(recording.artists.first?.links.first?.type == "wikidata")
        #expect(recording.release?.coverArt != nil)
    }

    @Test func recordingWithoutUserLinkHasNoLinkedRecording() async throws {
        let server = FakeListenBrainz(status: 404, body: #"{"status": "none"}"#)

        let linked = try await server.manager().linkedRecording(forMSID: "aaaaaaaa-0000-0000-0000-000000000001")

        #expect(linked == nil)
    }
}
