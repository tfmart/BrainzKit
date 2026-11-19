//
//  BZKISODate.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

enum BZKISODate {
    static func parse(_ string: String?) -> Date? {
        guard let string else { return nil }
        return try? Date.ISO8601FormatStyle().parse(string)
    }
}
