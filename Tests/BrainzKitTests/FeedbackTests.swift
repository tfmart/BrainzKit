//
//  FeedbackTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct FeedbackTests {
    @Test func recordingFeedbackIsLookedUpByEitherIdentifier() async throws {
        let server = FakeListenBrainz(body: #"{"feedback": [], "count": 0, "offset": 0, "total_count": 0}"#)
        let manager = server.manager(signedIn: false)

        _ = try await manager.feedback(forRecording: .mbid("738920d3-c6e6-41c7-b504-57761bb625fd"), score: .loved)
        let mbidRequest = try await server.lastRequest()
        _ = try await manager.feedback(forRecording: .msid("fd0cad33-ea33-453b-8155-1292379277db"))
        let msidRequest = try await server.lastRequest()

        #expect(mbidRequest.url?.path == "/1/feedback/recording/738920d3-c6e6-41c7-b504-57761bb625fd/get-feedback-mbid")
        #expect(mbidRequest.url?.query?.contains("score=1") == true)
        #expect(msidRequest.url?.path == "/1/feedback/recording/fd0cad33-ea33-453b-8155-1292379277db/get-feedback")
    }
}
