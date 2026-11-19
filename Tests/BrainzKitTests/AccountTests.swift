//
//  AccountTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct AccountTests {
    @Test func userWhoNeverImportedHasNoLatestImport() async throws {
        let server = FakeListenBrainz(body: #"{"latest_import": 0, "musicbrainz_id": "rob", "status": null, "error": null}"#)

        let latest = try await server.manager(signedIn: false).latestImport(forUser: "rob")

        #expect(latest == nil)
    }
}
