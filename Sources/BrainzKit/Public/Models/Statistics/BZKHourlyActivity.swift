//
//  BZKHourlyActivity.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The number of listens in one hour of one weekday.
public struct BZKHourlyActivity: Sendable, Hashable {
    /// The day of the week.
    public let weekday: BZKWeekday
    /// The hour of the day in UTC, from 0 to 23.
    public let hour: Int
    /// The number of listens.
    public let listenCount: Int
}
