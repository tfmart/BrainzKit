//
//  BZKListenSubmission.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// A listen to send to ListenBrainz.
///
/// Only ``artist`` and ``track`` are required. Every other value is optional, and providing MusicBrainz IDs or an ISRC helps ListenBrainz link the listen to the right recording.
public struct BZKListenSubmission: Sendable, Hashable {
    /// The artist name.
    public var artist: String
    /// The track name.
    public var track: String
    /// The release (album) name.
    public var release: String?
    /// When playback started. Ignored for now playing updates.
    public var listenedAt: Date
    /// The track's length.
    public var duration: TimeInterval?
    /// The track's position on the release.
    public var trackNumber: Int?
    /// The disc the track is on.
    public var discNumber: Int?
    /// The MusicBrainz recording ID.
    public var recordingMBID: String?
    /// The MusicBrainz release ID.
    public var releaseMBID: String?
    /// The MusicBrainz release group ID.
    public var releaseGroupMBID: String?
    /// The MusicBrainz artist IDs.
    public var artistMBIDs: [String]?
    /// The track's International Standard Recording Code.
    public var isrc: String?
    /// Tags describing the track. ListenBrainz accepts up to 50 tags of up to 64 characters each.
    public var tags: [String]?
    /// The domain of the service the music was played from, such as `music.apple.com`.
    public var musicService: String?
    /// The name of the service the music was played from, used when no domain is known.
    public var musicServiceName: String?
    /// A URL where the track can be played.
    public var originURL: URL?
    /// The name of the player that played the track, if different from your app.
    public var mediaPlayer: String?
    /// The version of the player that played the track.
    public var mediaPlayerVersion: String?

    /// Creates a listen.
    ///
    /// - Parameters:
    ///   - artist: The artist name.
    ///   - track: The track name.
    ///   - release: The release (album) name.
    ///   - listenedAt: When playback started.
    ///   - duration: The track's length.
    ///   - trackNumber: The track's position on the release.
    ///   - discNumber: The disc the track is on.
    ///   - recordingMBID: The MusicBrainz recording ID.
    ///   - releaseMBID: The MusicBrainz release ID.
    ///   - releaseGroupMBID: The MusicBrainz release group ID.
    ///   - artistMBIDs: The MusicBrainz artist IDs.
    ///   - isrc: The track's International Standard Recording Code.
    ///   - tags: Tags describing the track.
    ///   - musicService: The domain of the service the music was played from.
    ///   - musicServiceName: The name of the service the music was played from.
    ///   - originURL: A URL where the track can be played.
    ///   - mediaPlayer: The name of the player that played the track.
    ///   - mediaPlayerVersion: The version of the player that played the track.
    public init(
        artist: String,
        track: String,
        release: String? = nil,
        listenedAt: Date = Date(),
        duration: TimeInterval? = nil,
        trackNumber: Int? = nil,
        discNumber: Int? = nil,
        recordingMBID: String? = nil,
        releaseMBID: String? = nil,
        releaseGroupMBID: String? = nil,
        artistMBIDs: [String]? = nil,
        isrc: String? = nil,
        tags: [String]? = nil,
        musicService: String? = nil,
        musicServiceName: String? = nil,
        originURL: URL? = nil,
        mediaPlayer: String? = nil,
        mediaPlayerVersion: String? = nil
    ) {
        self.artist = artist
        self.track = track
        self.release = release
        self.listenedAt = listenedAt
        self.duration = duration
        self.trackNumber = trackNumber
        self.discNumber = discNumber
        self.recordingMBID = recordingMBID
        self.releaseMBID = releaseMBID
        self.releaseGroupMBID = releaseGroupMBID
        self.artistMBIDs = artistMBIDs
        self.isrc = isrc
        self.tags = tags
        self.musicService = musicService
        self.musicServiceName = musicServiceName
        self.originURL = originURL
        self.mediaPlayer = mediaPlayer
        self.mediaPlayerVersion = mediaPlayerVersion
    }
}
