//
//  BZKCoverArt.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// Cover art hosted by the Cover Art Archive.
public struct BZKCoverArt: Sendable, Hashable {
    /// The MusicBrainz release ID the image belongs to.
    public let releaseMBID: String
    /// The Cover Art Archive image ID.
    public let id: Int

    /// Creates a cover art reference.
    ///
    /// - Parameters:
    ///   - releaseMBID: The MusicBrainz release ID the image belongs to.
    ///   - id: The Cover Art Archive image ID.
    public init(releaseMBID: String, id: Int) {
        self.releaseMBID = releaseMBID
        self.id = id
    }

    init?(releaseMBID: String?, id: Int?) {
        guard let releaseMBID, let id else { return nil }
        self.init(releaseMBID: releaseMBID, id: id)
    }

    /// The URL of the image's thumbnail.
    ///
    /// - Parameter size: The thumbnail's edge length in pixels. The Cover Art Archive provides 250, 500, and 1200.
    public func url(size: Int = 500) -> URL? {
        URL(string: "https://coverartarchive.org/release/\(releaseMBID)/\(id)-\(size).jpg")
    }
}
