//
//  BZKRecordingMetadata.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// MusicBrainz details about a recording: its artists, canonical release, tags, and links.
public struct BZKRecordingMetadata: Sendable, Hashable, Decodable {
    /// The recording name.
    public let name: String
    /// The recording length in seconds, if known.
    public let duration: TimeInterval?
    /// The date of the recording's first release as an ISO 8601 date string, which may contain only a year or a year and month.
    public let firstReleaseDate: String?
    /// The recording's ISRCs.
    public let isrcs: [String]
    /// The credited artist name, if known.
    public let artistName: String?
    /// The individual artists in the credit.
    public let artists: [BZKArtistMetadata]
    /// The release MusicBrainz considers canonical for the recording, if known.
    public let release: BZKMetadataRelease?
    /// Links to the recording on streaming services and stores.
    public let links: [BZKLink]
    /// The recording's tags, including genres, most applied first.
    public let tags: [BZKTag]
    /// The tags of the recording's artists, most applied first.
    public let artistTags: [BZKTag]
    /// The tags of the recording's release group, most applied first.
    public let releaseGroupTags: [BZKTag]

    enum CodingKeys: String, CodingKey {
        case recording
        case artist
        case release
        case tag
    }

    enum RecordingKeys: String, CodingKey {
        case name
        case length
        case firstReleaseDate = "first_release_date"
        case isrcs
        case urlRels = "url_rels"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let recording = try container.nestedContainer(keyedBy: RecordingKeys.self, forKey: .recording)
        name = try recording.decode(String.self, forKey: .name)
        duration = try recording.decodeIfPresent(Double.self, forKey: .length).map { $0 / 1000 }
        firstReleaseDate = try recording.decodeIfPresent(String.self, forKey: .firstReleaseDate)
        isrcs = try recording.decodeIfPresent([String].self, forKey: .isrcs) ?? []
        let urlRels = (try? recording.decodeIfPresent([[String: String]].self, forKey: .urlRels)) ?? []
        links = urlRels.compactMap { rel in
            guard let type = rel["type"], let url = rel["url"].flatMap(URL.init(string:)) else { return nil }
            return BZKLink(type: type, url: url)
        }
        let credit = try? container.decodeIfPresent(BZKMetadataArtistCredit.self, forKey: .artist)
        artistName = credit?.name
        artists = credit?.artists ?? []
        release = try? container.decodeIfPresent(BZKMetadataRelease.self, forKey: .release)
        let tagGroups = try? container.decodeIfPresent(BZKMetadataTags.self, forKey: .tag)
        tags = tagGroups?.recording ?? []
        artistTags = tagGroups?.artist ?? []
        releaseGroupTags = tagGroups?.releaseGroup ?? []
    }
}
