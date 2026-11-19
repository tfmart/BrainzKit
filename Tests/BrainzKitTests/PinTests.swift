//
//  PinTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct PinTests {
    @Test func pinningSendsRecordingMessageAndExpiry() async throws {
        let server = FakeListenBrainz(body: """
        {
          "pinned_recording": {
            "row_id": 7,
            "recording_msid": "aaaaaaaa-0000-0000-0000-000000000001",
            "recording_mbid": null,
            "blurb_content": "On repeat",
            "created": 1700000000,
            "pinned_until": 1700604800
          }
        }
        """)

        let pin = try await server.manager().pin(
            .msid("aaaaaaaa-0000-0000-0000-000000000001"),
            blurb: "On repeat",
            until: Date(timeIntervalSince1970: 1700604800)
        )

        let body = try await server.lastJSONBody()
        #expect(body["recording_msid"] as? String == "aaaaaaaa-0000-0000-0000-000000000001")
        #expect(body["recording_mbid"] == nil)
        #expect(body["blurb_content"] as? String == "On repeat")
        #expect(body["pinned_until"] as? Int == 1700604800)
        #expect(pin.id == 7)
        #expect(pin.pinnedUntil == Date(timeIntervalSince1970: 1700604800))
    }

    @Test func userWithoutActivePinHasNoCurrentPin() async throws {
        let server = FakeListenBrainz(body: #"{"pinned_recording": null, "user_name": "rob"}"#)

        let pin = try await server.manager(signedIn: false).currentPin(forUser: "rob")

        #expect(pin == nil)
    }
}
