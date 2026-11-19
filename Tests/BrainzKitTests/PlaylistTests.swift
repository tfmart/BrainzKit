//
//  PlaylistTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct PlaylistTests {
    @Test func playlistExposesTracksWithIdentifiersDurationsAndArtwork() async throws {
        let server = FakeListenBrainz(body: """
        {
          "playlist": {
            "identifier": "https://listenbrainz.org/playlist/ffffffff-0000-0000-0000-000000000006",
            "title": "Weekly Exploration",
            "creator": "listenbrainz",
            "date": "2026-08-23T22:13:00.700111+00:00",
            "extension": {
              "https://musicbrainz.org/doc/jspf#playlist": {
                "created_for": "rob",
                "public": false,
                "last_modified_at": "2026-08-24T10:00:00.000000+00:00"
              }
            },
            "track": [
              {
                "title": "Fauna",
                "creator": "Carbon Based Lifeforms",
                "album": "Seeker",
                "duration": 331000,
                "identifier": ["https://musicbrainz.org/recording/22c7fa7f-2404-4103-8267-6a98b4b1f8ee"],
                "extension": {
                  "https://musicbrainz.org/doc/jspf#track": {
                    "added_at": "2026-08-23T22:13:00.700111+00:00",
                    "added_by": "troi-bot",
                    "artist_identifiers": ["https://musicbrainz.org/artist/8229a8f1-b315-4fae-af57-b3eb71efdaf4"],
                    "additional_metadata": {"caa_id": 36023983670, "caa_release_mbid": "77e9b1b4-e332-4c9b-859c-d397582dd64a"}
                  }
                }
              }
            ]
          }
        }
        """)

        let playlist = try await server.manager(signedIn: false).playlist(id: "ffffffff-0000-0000-0000-000000000006")

        #expect(playlist.id == "ffffffff-0000-0000-0000-000000000006")
        #expect(playlist.createdFor == "rob")
        #expect(playlist.isPublic == false)
        let createdAt = try #require(playlist.createdAt)
        #expect(abs(createdAt.timeIntervalSince1970 - 1787523180.700111) < 0.001)
        let track = try #require(playlist.tracks.first)
        #expect(track.recordingMBID == "22c7fa7f-2404-4103-8267-6a98b4b1f8ee")
        #expect(track.artistMBIDs == ["8229a8f1-b315-4fae-af57-b3eb71efdaf4"])
        #expect(track.duration == 331)
        #expect(track.coverArt == BZKCoverArt(releaseMBID: "77e9b1b4-e332-4c9b-859c-d397582dd64a", id: 36023983670))
    }

    @Test func playlistListsReportTotalForPaging() async throws {
        let server = FakeListenBrainz(body: """
        {
          "count": 1,
          "offset": 25,
          "playlist_count": 105,
          "playlists": [
            {"playlist": {"identifier": "https://listenbrainz.org/playlist/abc", "title": "Road Trip", "creator": "rob", "track": []}}
          ]
        }
        """)

        let page = try await server.manager(signedIn: false).playlists(forUser: "rob", offset: 25)

        #expect(page.totalCount == 105)
        #expect(page.playlists.map(\.title) == ["Road Trip"])
    }

    @Test func playlistWithoutTrackMetadataStillListsRecordings() async throws {
        let server = FakeListenBrainz(body: """
        {
          "playlist": {
            "identifier": "https://listenbrainz.org/playlist/abc",
            "title": "Road Trip",
            "creator": "rob",
            "track": [
              {
                "identifier": ["https://musicbrainz.org/recording/273c17b3-9e39-4dd4-bea7-ecaad28202e7"],
                "extension": {"https://musicbrainz.org/doc/jspf#track": {"added_by": "rob"}}
              }
            ]
          }
        }
        """)

        let playlist = try await server.manager(signedIn: false).playlist(id: "abc", includeTrackMetadata: false)

        #expect(playlist.tracks.map(\.recordingMBID) == ["273c17b3-9e39-4dd4-bea7-ecaad28202e7"])
        #expect(playlist.tracks.first?.title == nil)
        #expect(try await server.lastRequest().url?.query == "fetch_metadata=false")
    }
}
