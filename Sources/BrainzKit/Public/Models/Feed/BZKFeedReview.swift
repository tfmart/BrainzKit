//
//  BZKFeedReview.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A CritiqueBrainz review shown in a feed.
public struct BZKFeedReview: Sendable, Hashable {
    /// The name of the reviewed artist, release group, or recording.
    public let entityName: String
    /// The MusicBrainz ID of the reviewed entity.
    public let entityMBID: String
    /// The kind of entity reviewed, such as "artist", "release_group", or "recording".
    public let entityType: String
    /// The rating from 1 to 5, if the reviewer gave one.
    public let rating: Int?
    /// The review text.
    public let text: String
    /// The review's ID on CritiqueBrainz.
    public let reviewMBID: String
}
