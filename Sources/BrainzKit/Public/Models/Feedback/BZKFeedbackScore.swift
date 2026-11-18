//
//  BZKFeedbackScore.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The feedback a user gives a recording.
public enum BZKFeedbackScore: Int, Sendable, Hashable, Codable {
    /// The user loves the recording.
    case loved = 1
    /// The user hates the recording.
    case hated = -1
    /// No feedback. Submitting this score removes any existing feedback.
    case neutral = 0
}
