//
//  BZKServicePlaylist.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A playlist in the signed-in user's account on a streaming service.
public struct BZKServicePlaylist: Sendable, Hashable, Decodable, Identifiable {
    /// The playlist's ID on the service.
    public let id: String
    /// The playlist's name.
    public let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case attributes
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let id = try? container.decode(String.self, forKey: .id) {
            self.id = id
        } else {
            id = String(try container.decode(Int.self, forKey: .id))
        }
        let attributes = try? container.decodeIfPresent(BZKServicePlaylistAttributes.self, forKey: .attributes)
        name = (try? container.decodeIfPresent(String.self, forKey: .name))
            ?? (try? container.decodeIfPresent(String.self, forKey: .title))
            ?? attributes?.name
            ?? ""
    }
}
