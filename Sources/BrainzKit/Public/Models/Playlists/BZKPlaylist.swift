//
//  BZKPlaylist.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A ListenBrainz playlist.
public struct BZKPlaylist: Sendable, Hashable, Decodable, Identifiable {
    /// The playlist's MusicBrainz ID.
    public let id: String
    /// The playlist's title.
    public let title: String
    /// The playlist's description. It may contain HTML.
    public let annotation: String?
    /// The name of the user who created the playlist.
    public let creator: String
    /// The name of the user a generated playlist was made for, such as a weekly recommendation playlist.
    public let createdFor: String?
    /// The users who can edit the playlist.
    public let collaborators: [String]
    /// Whether anyone can see the playlist.
    public let isPublic: Bool
    /// When the playlist was created.
    public let createdAt: Date?
    /// When the playlist was last changed.
    public let lastModifiedAt: Date?
    /// The playlist's tracks. Lists of playlists leave this empty; fetch a playlist with ``BZKManager/playlist(id:)`` to get its tracks.
    public let tracks: [BZKPlaylistTrack]
    /// The playlist's page on listenbrainz.org.
    public var url: URL? {
        URL(string: "https://listenbrainz.org/playlist/\(id)")
    }

    enum CodingKeys: String, CodingKey {
        case identifier
        case title
        case annotation
        case creator
        case date
        case track
        case extensions = "extension"
    }

    enum ExtensionKeys: String, CodingKey {
        case playlist = "https://musicbrainz.org/doc/jspf#playlist"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let identifier = try container.decode(String.self, forKey: .identifier)
        id = identifier.split(separator: "/").last.map(String.init) ?? identifier
        title = try container.decode(String.self, forKey: .title)
        annotation = try container.decodeIfPresent(String.self, forKey: .annotation)
        creator = try container.decode(String.self, forKey: .creator)
        createdAt = BZKISODate.parse(try container.decodeIfPresent(String.self, forKey: .date))
        tracks = try container.decodeIfPresent([BZKPlaylistTrack].self, forKey: .track) ?? []
        let extensions = try? container.nestedContainer(keyedBy: ExtensionKeys.self, forKey: .extensions)
        let details = try? extensions?.decodeIfPresent(BZKPlaylistExtension.self, forKey: .playlist)
        createdFor = details?.createdFor
        collaborators = details?.collaborators ?? []
        isPublic = details?.isPublic ?? true
        lastModifiedAt = BZKISODate.parse(details?.lastModifiedAt)
    }
}
