//
//  BZKLink.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A link to an external site, such as a streaming service or an official homepage.
public struct BZKLink: Sendable, Hashable, Decodable {
    /// The MusicBrainz relationship type, such as "streaming", "official homepage", or "wikidata".
    public let type: String
    /// The link's URL.
    public let url: URL

    /// Creates a link.
    ///
    /// - Parameters:
    ///   - type: The MusicBrainz relationship type.
    ///   - url: The link's URL.
    public init(type: String, url: URL) {
        self.type = type
        self.url = url
    }
}
