//
//  BZKRadioPlaylist.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A playlist LB Radio generated from a prompt. It isn't saved; pass its tracks' recording IDs to ``BZKManager/createPlaylist(title:description:isPublic:collaborators:recordingMBIDs:)`` to keep it.
public struct BZKRadioPlaylist: Sendable, Hashable, Decodable {
    /// The generated title.
    public let title: String
    /// A description of how the playlist was generated.
    public let description: String?
    /// The playlist's tracks.
    public let tracks: [BZKPlaylistTrack]
    /// Notes from LB Radio about how it interpreted the prompt, such as which similar artists it used.
    public let notes: [String]

    enum CodingKeys: String, CodingKey {
        case jspf
        case notes = "feedback"
    }

    enum JSPFKeys: String, CodingKey {
        case playlist
    }

    enum PlaylistKeys: String, CodingKey {
        case title
        case annotation
        case track
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let jspf = try container.nestedContainer(keyedBy: JSPFKeys.self, forKey: .jspf)
        let playlist = try jspf.nestedContainer(keyedBy: PlaylistKeys.self, forKey: .playlist)
        title = try playlist.decode(String.self, forKey: .title)
        description = try playlist.decodeIfPresent(String.self, forKey: .annotation)
        tracks = try playlist.decodeIfPresent([BZKPlaylistTrack].self, forKey: .track) ?? []
        notes = try container.decodeIfPresent([String].self, forKey: .notes) ?? []
    }
}
