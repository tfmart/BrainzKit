//
//  BZKDailyActivityPayload.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKDailyActivityPayload: Decodable {
    let dailyActivity: [String: [BZKHourCount]]

    enum CodingKeys: String, CodingKey {
        case dailyActivity = "daily_activity"
    }

    var activity: [BZKHourlyActivity] {
        dailyActivity
            .compactMap { day, hours in BZKWeekday(rawValue: day).map { weekday in (weekday, hours) } }
            .flatMap { weekday, hours in
                hours.map { BZKHourlyActivity(weekday: weekday, hour: $0.hour, listenCount: $0.listenCount) }
            }
            .sorted { ($0.weekday, $0.hour) < ($1.weekday, $1.hour) }
    }
}
