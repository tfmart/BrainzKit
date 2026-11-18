//
//  AuthenticationTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct AuthenticationTests {
    @Test func validTokenSignsTheUserIn() async throws {
        let server = FakeListenBrainz(body: #"{"code": 200, "message": "Token valid.", "valid": true, "user_name": "rob"}"#)
        let manager = server.manager(signedIn: false)

        let userName = try await manager.signIn(token: "new-token")

        #expect(userName == "rob")
        #expect(await manager.userName == "rob")
        #expect(await manager.token == "new-token")
        #expect(try await server.lastRequest().value(forHTTPHeaderField: "Authorization") == "Token new-token")
    }

    @Test func invalidTokenLeavesTheUserSignedOut() async throws {
        let server = FakeListenBrainz(body: #"{"code": 200, "message": "Token invalid.", "valid": false}"#)
        let manager = server.manager(signedIn: false)

        await #expect(throws: BZKClientError.invalidToken) {
            try await manager.signIn(token: "bad-token")
        }
        #expect(await manager.token == nil)
        #expect(await manager.userName == nil)
    }
}
