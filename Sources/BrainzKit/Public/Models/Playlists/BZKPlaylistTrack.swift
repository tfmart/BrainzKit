//
//  BZKPlaylistTrack.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A track in a ListenBrainz playlist.
public struct BZKPlaylistTrack: Sendable, Hashable, Decodable {
    /// The track name. `nil` when the playlist was fetched without track metadata.
    public let title: String?
    /// The credited artist name. `nil` when the playlist was fetched without track metadata.
    public let artistName: String?
    /// The album name, if known.
    public let album: String?
    /// The track length in seconds, if known.
    public let duration: TimeInterval?
    /// The MusicBrainz recording ID.
    public let recordingMBID: String?
    /// The MusicBrainz artist IDs.
    public let artistMBIDs: [String]
    /// The individual artists in the credit, if known.
    public let artists: [BZKArtistCredit]?
    /// The album's cover art, if available.
    public let coverArt: BZKCoverArt?
    /// When the track was added to the playlist.
    public let addedAt: Date?
    /// The name of the user who added the track.
    public let addedBy: String?

    enum CodingKeys: String, CodingKey {
        case title
        case artistName = "creator"
        case album
        case duration
        case identifier
        case extensions = "extension"
    }

    enum ExtensionKeys: String, CodingKey {
        case track = "https://musicbrainz.org/doc/jspf#track"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        artistName = try container.decodeIfPresent(String.self, forKey: .artistName)
        album = try container.decodeIfPresent(String.self, forKey: .album)
        duration = try container.decodeIfPresent(Double.self, forKey: .duration).map { $0 / 1000 }
        let identifiers = (try? container.decodeIfPresent([String].self, forKey: .identifier))
            ?? (try? container.decodeIfPresent(String.self, forKey: .identifier)).flatMap { $0.map { [$0] } }
            ?? []
        recordingMBID = identifiers.first.map { $0.split(separator: "/").last.map(String.init) ?? $0 }
        let extensions = try? container.nestedContainer(keyedBy: ExtensionKeys.self, forKey: .extensions)
        let details = try? extensions?.decodeIfPresent(BZKPlaylistTrackExtension.self, forKey: .track)
        artistMBIDs = (details?.artistIdentifiers ?? []).compactMap { $0.split(separator: "/").last.map(String.init) }
        artists = details?.additionalMetadata?.artists
        coverArt = BZKCoverArt(releaseMBID: details?.additionalMetadata?.caaReleaseMBID, id: details?.additionalMetadata?.caaID)
        addedAt = BZKISODate.parse(details?.addedAt)
        addedBy = details?.addedBy
    }
}
