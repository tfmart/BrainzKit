//
//  PlaylistEditingTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct PlaylistEditingTests {
    @Test func creatingPlaylistSendsVisibilityAndTrackIdentifiers() async throws {
        let server = FakeListenBrainz(body: #"{"status": "ok", "playlist_mbid": "ffffffff-0000-0000-0000-000000000006"}"#)

        let id = try await server.manager().createPlaylist(
            title: "Road Trip",
            isPublic: false,
            recordingMBIDs: ["22c7fa7f-2404-4103-8267-6a98b4b1f8ee"]
        )

        #expect(id == "ffffffff-0000-0000-0000-000000000006")
        let playlist = try #require(try await server.lastJSONBody()["playlist"] as? [String: Any])
        #expect(playlist["title"] as? String == "Road Trip")
        let extensions = try #require(playlist["extension"] as? [String: [String: Any]])
        #expect(extensions["https://musicbrainz.org/doc/jspf#playlist"]?["public"] as? Bool == false)
        let tracks = try #require(playlist["track"] as? [[String: [String]]])
        #expect(tracks.map { $0["identifier"] } == [["https://musicbrainz.org/recording/22c7fa7f-2404-4103-8267-6a98b4b1f8ee"]])
    }

    @Test func editingWithoutCollaboratorsKeepsTheCurrentOnes() async throws {
        let server = FakeListenBrainz(body: """
        {
          "status": "ok",
          "playlist": {
            "identifier": "https://listenbrainz.org/playlist/abc",
            "title": "Road Trip",
            "creator": "listener",
            "extension": {"https://musicbrainz.org/doc/jspf#playlist": {"collaborators": ["alice"], "public": true}},
            "track": []
          }
        }
        """)

        try await server.manager().editPlaylist(id: "abc", title: "Summer Road Trip")

        let playlist = try #require(try await server.lastJSONBody()["playlist"] as? [String: Any])
        #expect(playlist["title"] as? String == "Summer Road Trip")
        let extensions = try #require(playlist["extension"] as? [String: [String: Any]])
        #expect(extensions["https://musicbrainz.org/doc/jspf#playlist"]?["collaborators"] as? [String] == ["alice"])
    }

    @Test func addingMoreThanOneHundredTracksKeepsTheirPositions() async throws {
        let server = FakeListenBrainz()
        let mbids = (0..<150).map { String(format: "00000000-0000-0000-0000-%012d", $0) }

        try await server.manager().addTracks(mbids, toPlaylist: "abc", at: 5)

        let requests = await server.log.requests
        #expect(requests.map { $0.url?.path } == ["/1/playlist/abc/item/add/5", "/1/playlist/abc/item/add/105"])
        let sent = try requests.flatMap { request -> [String] in
            let body = try #require(request.httpBody)
            let json = try #require(try JSONSerialization.jsonObject(with: body) as? [String: [String: [[String: [String]]]]])
            return (json["playlist"]?["track"] ?? []).compactMap { $0["identifier"]?.first }
        }
        #expect(sent == mbids.map { "https://musicbrainz.org/recording/\($0)" })
    }

    @Test func servicePlaylistsReadEachServicesFormat() async throws {
        let server = FakeListenBrainz(body: """
        [
          {"id": "37i9dQZF1DXcBWIGoYBM5M", "name": "Today's Top Hits", "tracks": {"total": 50}},
          {"id": "p.YJXV7Q9fRvLzZ", "type": "library-playlists", "attributes": {"name": "Road Trip"}},
          {"id": 1234567, "title": "Late Night Mix", "kind": "playlist"}
        ]
        """)

        let playlists = try await server.manager().servicePlaylists(on: .spotify)

        #expect(playlists.map(\.id) == ["37i9dQZF1DXcBWIGoYBM5M", "p.YJXV7Q9fRvLzZ", "1234567"])
        #expect(playlists.map(\.name) == ["Today's Top Hits", "Road Trip", "Late Night Mix"])
    }
}
