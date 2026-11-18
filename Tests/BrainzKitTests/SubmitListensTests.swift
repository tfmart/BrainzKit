//
//  SubmitListensTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct SubmitListensTests {
    @Test func listenIsSentInListenBrainzSubmissionFormat() async throws {
        let server = FakeListenBrainz()
        let listen = BZKListenSubmission(
            artist: "Daft Punk",
            track: "One More Time",
            release: "Discovery",
            listenedAt: Date(timeIntervalSince1970: 1_443_521_965.7),
            duration: 320.4
        )

        try await server.manager().submitListen(listen)

        let request = try await server.lastRequest()
        #expect(request.httpMethod == "POST")
        #expect(request.url?.absoluteString == "https://api.listenbrainz.org/1/submit-listens")
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Token user-token")
        #expect(request.value(forHTTPHeaderField: "User-Agent") == "TestPlayer/2.1 ( https://example.com )")

        let body = try await server.lastJSONBody()
        #expect(body["listen_type"] as? String == "single")
        let payload = try #require((body["payload"] as? [[String: Any]])?.first)
        #expect(payload["listened_at"] as? Int == 1_443_521_965)
        let metadata = try #require(payload["track_metadata"] as? [String: Any])
        #expect(metadata["artist_name"] as? String == "Daft Punk")
        #expect(metadata["track_name"] as? String == "One More Time")
        #expect(metadata["release_name"] as? String == "Discovery")
        let info = try #require(metadata["additional_info"] as? [String: Any])
        #expect(info["duration_ms"] as? Int == 320_400)
        #expect(info["submission_client"] as? String == "TestPlayer")
        #expect(info["submission_client_version"] as? String == "2.1")
        #expect(info["recording_mbid"] == nil)
    }

    @Test func playingNowOmitsTimestampAndReturnsRecordingMSID() async throws {
        let server = FakeListenBrainz(body: #"{"status": "ok", "recording_msid": "d23f4719-9212-49f0-ad08-ddbfbfc50d6f"}"#)

        let msid = try await server.manager().updatePlayingNow(BZKListenSubmission(artist: "Björk", track: "Jóga"))

        #expect(msid == "d23f4719-9212-49f0-ad08-ddbfbfc50d6f")
        #expect(try await server.lastRequest().url?.query == "return_msid=true")
        let body = try await server.lastJSONBody()
        #expect(body["listen_type"] as? String == "playing_now")
        let payload = try #require((body["payload"] as? [[String: Any]])?.first)
        #expect(payload["listened_at"] == nil)
    }

    @Test func signedOutSubmissionFailsWithoutContactingListenBrainz() async throws {
        let server = FakeListenBrainz()

        await #expect(throws: BZKClientError.missingToken) {
            try await server.manager(signedIn: false).submitListen(BZKListenSubmission(artist: "Air", track: "La Femme d'Argent"))
        }
        #expect(await server.log.requests.isEmpty)
    }

    @Test func importAcceptsOneToOneThousandListensPerRequest() async throws {
        let server = FakeListenBrainz()
        let manager = server.manager()
        let listen = BZKListenSubmission(artist: "Air", track: "Sexy Boy", listenedAt: Date(timeIntervalSince1970: 1_700_000_000))

        await #expect(throws: BZKClientError.noListens) {
            try await manager.importListens([])
        }
        await #expect(throws: BZKClientError.tooManyListens) {
            try await manager.importListens(Array(repeating: listen, count: 1001))
        }
        #expect(await server.log.requests.isEmpty)

        try await manager.importListens(Array(repeating: listen, count: 1000))

        let body = try await server.lastJSONBody()
        #expect(body["listen_type"] as? String == "import")
        #expect((body["payload"] as? [Any])?.count == 1000)
    }
}
