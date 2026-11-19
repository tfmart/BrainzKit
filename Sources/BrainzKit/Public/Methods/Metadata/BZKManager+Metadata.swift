//
//  BZKManager+Metadata.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// Finds the MusicBrainz recording for an artist and track name.
    ///
    /// Use the returned ``BZKRecordingMatch/recordingMBID`` to enrich a ``BZKListenSubmission`` or to submit feedback.
    ///
    /// - Parameters:
    ///   - artist: The artist name.
    ///   - track: The track name.
    ///   - release: The release name, which improves accuracy when provided.
    /// - Returns: The best match, or `nil` if ListenBrainz found none.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    func lookupRecording(artist: String, track: String, release: String? = nil) async throws -> BZKRecordingMatch? {
        let request = try BZKRequest(
            path: "metadata/lookup/",
            queryItems: BZKRequest.query([
                "artist_name": artist,
                "recording_name": track,
                "release_name": release
            ]),
            token: requiredToken()
        )
        let response: BZKLookupResponse = try await perform(request)
        return response.match
    }

    /// Fetches MusicBrainz details for recordings, including artists, canonical release, tags, and links.
    ///
    /// - Parameter mbids: Up to 1000 MusicBrainz recording IDs.
    /// - Returns: The metadata for each recording MusicBrainz knows, keyed by recording ID.
    func recordingMetadata(for mbids: [String]) async throws -> [String: BZKRecordingMetadata] {
        let body = BZKRecordingMetadataBody(recordingMBIDs: mbids)
        let request = try BZKRequest(method: .post, path: "metadata/recording/", body: encode(body))
        return try await perform(request)
    }

    /// Fetches MusicBrainz details for artists, including tags and links.
    ///
    /// - Parameter mbids: MusicBrainz artist IDs.
    /// - Returns: The metadata for each artist MusicBrainz knows.
    func artistMetadata(for mbids: [String]) async throws -> [BZKArtistMetadata] {
        let request = BZKRequest(
            path: "metadata/artist/",
            queryItems: BZKRequest.query(["artist_mbids": mbids.joined(separator: ","), "inc": "tag"])
        )
        return try await perform(request)
    }

    /// Fetches MusicBrainz details for release groups, such as albums and singles.
    ///
    /// - Parameter mbids: MusicBrainz release group IDs.
    /// - Returns: The metadata for each release group MusicBrainz knows, keyed by release group ID.
    func releaseGroupMetadata(for mbids: [String]) async throws -> [String: BZKReleaseGroupMetadata] {
        let request = BZKRequest(
            path: "metadata/release_group/",
            queryItems: BZKRequest.query(["release_group_mbids": mbids.joined(separator: ","), "inc": "artist tag release"])
        )
        return try await perform(request)
    }

    /// Links a recording that ListenBrainz couldn't match, or matched wrongly, to the correct MusicBrainz recording.
    ///
    /// The link applies to the signed-in user's listens of that recording.
    ///
    /// - Parameters:
    ///   - recordingMSID: The ListenBrainz recording MSID, such as a listen's ``BZKListen/recordingMSID``.
    ///   - recordingMBID: The correct MusicBrainz recording ID.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if either ID is invalid.
    func linkRecording(msid recordingMSID: String, toMBID recordingMBID: String) async throws {
        let body = BZKManualMapping(recordingMSID: recordingMSID, recordingMBID: recordingMBID)
        let request = try BZKRequest(method: .post, path: "metadata/submit_manual_mapping/", body: encode(body), token: requiredToken())
        try await send(request)
    }

    /// Fetches the MusicBrainz recording the signed-in user linked to a recording with ``linkRecording(msid:toMBID:)``.
    ///
    /// - Parameter recordingMSID: The ListenBrainz recording MSID.
    /// - Returns: The linked MusicBrainz recording ID, or `nil` if the user hasn't linked one.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in.
    func linkedRecording(forMSID recordingMSID: String) async throws -> String? {
        let request = try BZKRequest(
            path: "metadata/get_manual_mapping/",
            queryItems: BZKRequest.query(["recording_msid": recordingMSID]),
            token: requiredToken()
        )
        do {
            let response: BZKManualMappingResponse = try await perform(request)
            return response.mapping.recordingMBID
        } catch let error as BZKError where error.statusCode == 404 {
            return nil
        }
    }
}
