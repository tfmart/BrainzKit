//
//  ErrorTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct ErrorTests {
    @Test func rateLimitedRequestReportsMessageAndResetDelay() async throws {
        let server = FakeListenBrainz(
            status: 429,
            body: #"{"code": 429, "error": "Too many requests."}"#,
            headers: ["X-RateLimit-Reset-In": "7"]
        )

        let error = await #expect(throws: BZKError.self) {
            try await server.manager().listenCount(forUser: "rob")
        }

        #expect(error?.isRateLimited == true)
        #expect(error?.message == "Too many requests.")
        #expect(error?.rateLimitResetIn == 7)
    }
}
