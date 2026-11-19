//
//  BZKManager+Popularity.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Fetches how many listens and listeners recordings have across ListenBrainz.
    ///
    /// - Parameter mbids: Up to 1000 MusicBrainz recording IDs.
    /// - Returns: The popularity of each recording, in the order requested.
    func popularity(ofRecordings mbids: [String]) async throws -> [BZKPopularity] {
        try await popularity(path: "recording", key: "recording_mbids", mbids: mbids)
    }

    /// Fetches how many listens and listeners artists have across ListenBrainz.
    ///
    /// - Parameter mbids: Up to 1000 MusicBrainz artist IDs.
    /// - Returns: The popularity of each artist, in the order requested.
    func popularity(ofArtists mbids: [String]) async throws -> [BZKPopularity] {
        try await popularity(path: "artist", key: "artist_mbids", mbids: mbids)
    }

    /// Fetches how many listens and listeners releases have across ListenBrainz.
    ///
    /// - Parameter mbids: Up to 1000 MusicBrainz release IDs.
    /// - Returns: The popularity of each release, in the order requested.
    func popularity(ofReleases mbids: [String]) async throws -> [BZKPopularity] {
        try await popularity(path: "release", key: "release_mbids", mbids: mbids)
    }

    /// Fetches how many listens and listeners release groups have across ListenBrainz.
    ///
    /// - Parameter mbids: Up to 1000 MusicBrainz release group IDs.
    /// - Returns: The popularity of each release group, in the order requested.
    func popularity(ofReleaseGroups mbids: [String]) async throws -> [BZKPopularity] {
        try await popularity(path: "release-group", key: "release_group_mbids", mbids: mbids)
    }

    /// Fetches an artist's most listened recordings across ListenBrainz.
    ///
    /// Requires a signed-in user.
    ///
    /// - Parameter artistMBID: The MusicBrainz artist ID.
    /// - Returns: The artist's recordings, most listened first.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    func topRecordings(forArtist artistMBID: String) async throws -> [BZKArtistTopRecording] {
        let request = try BZKRequest(
            path: "popularity/top-recordings-for-artist/\(BZKRequest.segment(artistMBID))",
            token: requiredToken()
        )
        return try await perform(request)
    }

    /// Fetches an artist's most listened albums, singles, and other release groups across ListenBrainz.
    ///
    /// Requires a signed-in user.
    ///
    /// - Parameter artistMBID: The MusicBrainz artist ID.
    /// - Returns: The artist's release groups, most listened first.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    func topReleaseGroups(forArtist artistMBID: String) async throws -> [BZKArtistTopReleaseGroup] {
        let request = try BZKRequest(
            path: "popularity/top-release-groups-for-artist/\(BZKRequest.segment(artistMBID))",
            token: requiredToken()
        )
        return try await perform(request)
    }
}

extension BZKManager {
    func popularity(path: String, key: String, mbids: [String]) async throws -> [BZKPopularity] {
        let request = try BZKRequest(method: .post, path: "popularity/\(path)", body: encode([key: mbids]))
        return try await perform(request)
    }
}
