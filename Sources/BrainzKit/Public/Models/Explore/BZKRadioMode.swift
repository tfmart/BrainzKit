//
//  BZKRadioMode.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// How adventurous LB Radio is: easy sticks to popular tracks, hard digs deeper.
public enum BZKRadioMode: String, Sendable, Hashable, CaseIterable {
    /// Mostly popular, familiar tracks.
    case easy
    /// A mix of popular and less known tracks.
    case medium
    /// Mostly less known tracks.
    case hard
}
