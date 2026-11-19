//
//  BZKFeedEventContent.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// What a feed event shows.
public enum BZKFeedEventContent: Sendable, Hashable {
    /// A user listened to a track.
    case listen(BZKTrackMetadata)
    /// A user recommended a track to their followers.
    case recordingRecommendation(BZKTrackMetadata)
    /// A user recommended a track to specific users, with an optional message.
    case personalRecommendation(BZKTrackMetadata, recipients: [String], message: String?)
    /// A user pinned a track, with an optional message.
    case pin(BZKTrackMetadata, message: String?)
    /// One user followed another.
    case follow(follower: String, followed: String)
    /// A message from ListenBrainz, which may contain HTML.
    case notification(message: String)
    /// A user wrote a CritiqueBrainz review.
    case review(BZKFeedReview)
    /// One user thanked another, with an optional message.
    case thanks(thanker: String, thankee: String, message: String?)
    /// An event this version of BrainzKit doesn't recognize.
    case unknown
}
