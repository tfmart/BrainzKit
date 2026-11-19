//
//  RecommendationTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct RecommendationTests {
    @Test func badRecommendationRatingUsesListenBrainzName() async throws {
        let server = FakeListenBrainz()

        try await server.manager().rateRecommendation(.badRecommendation, recordingMBID: "5b44c236-cbb0-4e54-a8b1-c344b76e1b8f")

        let body = try await server.lastJSONBody()
        #expect(body["rating"] as? String == "bad_recommendation")
        #expect(body["recording_mbid"] as? String == "5b44c236-cbb0-4e54-a8b1-c344b76e1b8f")
    }
}
