//
//  FeedTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct FeedTests {
    @Test func feedEventsExposeWhatEachEventShows() async throws {
        let server = FakeListenBrainz(body: """
        {
          "payload": {
            "count": 3,
            "user_id": "listener",
            "events": [
              {
                "id": 12, "event_type": "recording_pin", "user_name": "rob", "created": 1700000300, "hidden": false,
                "metadata": {"blurb_content": "On repeat", "track_metadata": {"artist_name": "Air", "track_name": "Sexy Boy"}}
              },
              {
                "id": 11, "event_type": "follow", "user_name": "rob", "created": 1700000200, "hidden": false,
                "metadata": {"user_name_0": "rob", "user_name_1": "alice", "relationship_type": "follow", "created": 1700000200}
              },
              {
                "id": 10, "event_type": "something_new", "user_name": "rob", "created": 1700000100, "hidden": true,
                "metadata": {}
              }
            ]
          }
        }
        """)

        let events = try await server.manager().feedEvents()

        #expect(try await server.lastRequest().url?.path == "/1/user/listener/feed/events")
        guard case .pin(let track, let message) = events[0].content else {
            Issue.record("Expected a pin, got \(events[0].content)")
            return
        }
        #expect(track.trackName == "Sexy Boy")
        #expect(message == "On repeat")
        #expect(events[1].content == .follow(follower: "rob", followed: "alice"))
        #expect(events[2].kind == nil)
        #expect(events[2].content == .unknown)
        #expect(events[2].isHidden)
    }

    @Test func hidingAndDeletingIdentifyEventsTheWayListenBrainzExpects() async throws {
        let server = FakeListenBrainz()
        let manager = server.manager()

        try await manager.hideFeedEvent(id: 12, kind: .pin)
        let hideBody = try await server.lastJSONBody()
        try await manager.deleteFeedEvent(id: 7, kind: .recordingRecommendation)
        let deleteBody = try await server.lastJSONBody()

        #expect(hideBody["event_type"] as? String == "recording_pin")
        #expect(hideBody["event_id"] as? Int == 12)
        #expect(deleteBody["event_type"] as? String == "recording_recommendation")
        #expect(deleteBody["id"] as? Int == 7)
    }

    @Test func thankingReferencesTheOriginalEvent() async throws {
        let server = FakeListenBrainz()

        try await server.manager().thankFeedEvent(id: 12, kind: .pin, message: "Great pick")

        let metadata = try #require(try await server.lastJSONBody()["metadata"] as? [String: Any])
        #expect(metadata["original_event_type"] as? String == "recording_pin")
        #expect(metadata["original_event_id"] as? Int == 12)
        #expect(metadata["blurb_content"] as? String == "Great pick")
    }
}
