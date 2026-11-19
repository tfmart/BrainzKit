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

    @Test func dumpReportsWhenItWasCreated() async throws {
        let server = FakeListenBrainz(body: #"{"id": 2797, "dump_type": "incremental", "timestamp": "20261119-000003"}"#)

        let dump = try await server.manager(signedIn: false).dump()

        #expect(dump.createdAt == Date(timeIntervalSince1970: 1795046403))
    }
}
