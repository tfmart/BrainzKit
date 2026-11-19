//
//  BZKMetadataTags.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKMetadataTags: Decodable {
    let recording: [BZKTag]?
    let artist: [BZKTag]?
    let releaseGroup: [BZKTag]?

    enum CodingKeys: String, CodingKey {
        case recording
        case artist
        case releaseGroup = "release_group"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recording = try container.decodeIfPresent([BZKTag].self, forKey: .recording).map(Self.ranked)
        artist = try container.decodeIfPresent([BZKTag].self, forKey: .artist).map(Self.ranked)
        releaseGroup = try container.decodeIfPresent([BZKTag].self, forKey: .releaseGroup).map(Self.ranked)
    }

    static func ranked(_ tags: [BZKTag]) -> [BZKTag] {
        tags.sorted { $0.count > $1.count }
    }
}
