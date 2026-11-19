//
//  BZKFeedEventKind.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// The kind of a feed event.
public enum BZKFeedEventKind: String, Sendable, Hashable, CaseIterable, Codable {
    /// A user listened to a track.
    case listen
    /// A user recommended a track to their followers.
    case recordingRecommendation = "recording_recommendation"
    /// A user recommended a track to specific users.
    case personalRecommendation = "personal_recording_recommendation"
    /// A user pinned a track.
    case pin = "recording_pin"
    /// A user followed another user.
    case follow
    /// A message from ListenBrainz.
    case notification
    /// A user wrote a CritiqueBrainz review.
    case review = "critiquebrainz_review"
    /// A user thanked another user for an event.
    case thanks
}
