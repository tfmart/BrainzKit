//
//  BZKSubmittedAdditionalInfo.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

struct BZKSubmittedAdditionalInfo: Encodable {
    let submissionClient: String
    let submissionClientVersion: String
    let durationMs: Int?
    let tracknumber: Int?
    let discnumber: Int?
    let recordingMBID: String?
    let releaseMBID: String?
    let releaseGroupMBID: String?
    let artistMBIDs: [String]?
    let isrc: String?
    let tags: [String]?
    let musicService: String?
    let musicServiceName: String?
    let originURL: String?
    let mediaPlayer: String?
    let mediaPlayerVersion: String?

    enum CodingKeys: String, CodingKey {
        case submissionClient = "submission_client"
        case submissionClientVersion = "submission_client_version"
        case durationMs = "duration_ms"
        case tracknumber
        case discnumber
        case recordingMBID = "recording_mbid"
        case releaseMBID = "release_mbid"
        case releaseGroupMBID = "release_group_mbid"
        case artistMBIDs = "artist_mbids"
        case isrc
        case tags
        case musicService = "music_service"
        case musicServiceName = "music_service_name"
        case originURL = "origin_url"
        case mediaPlayer = "media_player"
        case mediaPlayerVersion = "media_player_version"
    }

    init(listen: BZKListenSubmission, clientInfo: BZKClientInfo) {
        submissionClient = clientInfo.name
        submissionClientVersion = clientInfo.version
        durationMs = listen.duration.map { Int(($0 * 1000).rounded()) }
        tracknumber = listen.trackNumber
        discnumber = listen.discNumber
        recordingMBID = listen.recordingMBID
        releaseMBID = listen.releaseMBID
        releaseGroupMBID = listen.releaseGroupMBID
        artistMBIDs = listen.artistMBIDs
        isrc = listen.isrc
        tags = listen.tags
        musicService = listen.musicService
        musicServiceName = listen.musicServiceName
        originURL = listen.originURL?.absoluteString
        mediaPlayer = listen.mediaPlayer
        mediaPlayerVersion = listen.mediaPlayerVersion
    }
}
