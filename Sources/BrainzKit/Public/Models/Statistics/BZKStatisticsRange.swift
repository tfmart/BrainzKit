//
//  BZKStatisticsRange.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The time range statistics are calculated over.
public enum BZKStatisticsRange: String, Sendable, Hashable, CaseIterable, Decodable {
    /// All listens.
    case allTime = "all_time"
    /// The last full week.
    case week
    /// The last full month.
    case month
    /// The last full quarter.
    case quarter
    /// The last full half year.
    case halfYearly = "half_yearly"
    /// The last full year.
    case year
    /// The current week so far.
    case thisWeek = "this_week"
    /// The current month so far.
    case thisMonth = "this_month"
    /// The current year so far.
    case thisYear = "this_year"
}
