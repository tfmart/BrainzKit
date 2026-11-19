//
//  BZKFeedEvent.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// An event in a user's feed, such as a listen, pin, or recommendation from someone they follow.
public struct BZKFeedEvent: Sendable, Hashable, Decodable {
    /// The event's ID, used to hide or delete it. Listen events have no ID.
    public let id: Int?
    /// The kind of event, or `nil` if this version of BrainzKit doesn't recognize it.
    public let kind: BZKFeedEventKind?
    /// The name of the user the event is about.
    public let userName: String
    /// When the event happened.
    public let createdAt: Date
    /// Whether the signed-in user hid the event.
    public let isHidden: Bool
    /// How similar the user's taste is to the signed-in user's, from 0 to 1. Present on listens from similar users.
    public let similarity: Double?
    /// What the event shows.
    public let content: BZKFeedEventContent

    enum CodingKeys: String, CodingKey {
        case id
        case kind = "event_type"
        case userName = "user_name"
        case createdAt = "created"
        case isHidden = "hidden"
        case similarity
        case metadata
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        kind = (try? container.decodeIfPresent(String.self, forKey: .kind)).flatMap { $0.flatMap(BZKFeedEventKind.init(rawValue:)) }
        userName = try container.decode(String.self, forKey: .userName)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        isHidden = try container.decodeIfPresent(Bool.self, forKey: .isHidden) ?? false
        similarity = try container.decodeIfPresent(Double.self, forKey: .similarity)
        let metadata = try? container.decodeIfPresent(BZKFeedEventMetadata.self, forKey: .metadata)
        content = metadata?.content(for: kind) ?? .unknown
    }
}
