//
//  BZKWeekday.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A day of the week.
public enum BZKWeekday: String, Sendable, Hashable, CaseIterable, Comparable, Decodable {
    /// Monday.
    case monday = "Monday"
    /// Tuesday.
    case tuesday = "Tuesday"
    /// Wednesday.
    case wednesday = "Wednesday"
    /// Thursday.
    case thursday = "Thursday"
    /// Friday.
    case friday = "Friday"
    /// Saturday.
    case saturday = "Saturday"
    /// Sunday.
    case sunday = "Sunday"

    /// Orders weekdays from Monday to Sunday.
    public static func < (lhs: BZKWeekday, rhs: BZKWeekday) -> Bool {
        let order = allCases
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}
