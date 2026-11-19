//
//  SettingsTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct SettingsTests {
    @Test func removingFlairSendsAnExplicitNull() async throws {
        let server = FakeListenBrainz(body: #"{"success": true}"#)

        try await server.manager().setFlair(nil)

        let body = try await server.lastJSONBody()
        #expect(body.keys.contains("flair"))
        #expect(body["flair"] is NSNull)
    }

    @Test func brainzPlayerPreferencesUseListenBrainzNames() async throws {
        let server = FakeListenBrainz()

        try await server.manager().setBrainzPlayerPreferences(BZKBrainzPlayerPreferences(isEnabled: true, servicePriority: ["spotify", "youtube"]))

        let body = try await server.lastJSONBody()
        #expect(body["brainzplayerEnabled"] as? Bool == true)
        #expect(body["dataSourcesPriority"] as? [String] == ["spotify", "youtube"])
        #expect(body.count == 2)
    }
}
