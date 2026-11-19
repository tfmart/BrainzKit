//
//  ListeningInsightsTests.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation
import Testing
import BrainzKit

@Suite struct ListeningInsightsTests {
    @Test func hourlyActivityRunsFromMondayToSundayByHour() async throws {
        let server = FakeListenBrainz(body: """
        {
          "payload": {
            "daily_activity": {
              "Sunday": [{"hour": 0, "listen_count": 4}],
              "Monday": [{"hour": 9, "listen_count": 12}, {"hour": 8, "listen_count": 7}]
            },
            "range": "week"
          }
        }
        """)

        let activity = try await server.manager(signedIn: false).hourlyActivity(forUser: "rob", range: .week)

        #expect(activity.map(\.weekday) == [.monday, .monday, .sunday])
        #expect(activity.map(\.hour) == [8, 9, 0])
        #expect(activity.map(\.listenCount) == [7, 12, 4])
    }

    @Test func usersWithoutReportedSimilarityHaveNone() async throws {
        let server = FakeListenBrainz(status: 204, body: "")

        let similarity = try await server.manager(signedIn: false).similarity(ofUser: "rob", to: "alice")

        #expect(similarity == nil)
    }

    @Test func yearInMusicRanksSimilarUsersAndKeysListensByReleaseYear() async throws {
        let server = FakeListenBrainz(body: """
        {
          "payload": {
            "user_name": "rob",
            "year": 2024,
            "data": {
              "total_listen_count": 21705,
              "day_of_week": "Wednesday",
              "most_listened_year": {"1998": 120, "2024": 900},
              "similar_users": {"alice": 0.05, "bob": 0.11}
            }
          }
        }
        """)

        let summary = try await server.manager(signedIn: false).yearInMusic(forUser: "rob", year: 2024)

        #expect(summary.totalListenCount == 21705)
        #expect(summary.mostActiveWeekday == .wednesday)
        #expect(summary.listensByReleaseYear == [1998: 120, 2024: 900])
        #expect(summary.similarUsers.map(\.userName) == ["bob", "alice"])
        #expect(summary.topArtists.isEmpty)
    }

    @Test func artistEvolutionLabelsNumericAndNamedPeriods() async throws {
        let server = FakeListenBrainz(body: """
        {
          "payload": {
            "artist_evolution_activity": [
              {"artist_name": "Air", "listen_count": 3, "time_unit": 31},
              {"artist_name": "Air", "listen_count": 5, "time_unit": "September"}
            ],
            "range": "month"
          }
        }
        """)

        let rows = try await server.manager(signedIn: false).artistEvolution(for: .sitewide, range: .month)

        #expect(rows.map(\.period) == ["31", "September"])
    }
}
