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
}
