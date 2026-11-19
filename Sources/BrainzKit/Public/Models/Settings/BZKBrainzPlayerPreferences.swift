//
//  BZKBrainzPlayerPreferences.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

/// Which music services BrainzPlayer on listenbrainz.org uses to play tracks.
public struct BZKBrainzPlayerPreferences: Sendable, Hashable, Encodable {
    /// Whether BrainzPlayer is enabled at all.
    public var isEnabled: Bool?
    /// Whether YouTube is used.
    public var youtubeEnabled: Bool?
    /// Whether Spotify is used.
    public var spotifyEnabled: Bool?
    /// Whether SoundCloud is used.
    public var soundcloudEnabled: Bool?
    /// Whether Apple Music is used.
    public var appleMusicEnabled: Bool?
    /// Whether Funkwhale is used.
    public var funkwhaleEnabled: Bool?
    /// Whether Navidrome is used.
    public var navidromeEnabled: Bool?
    /// Whether the Internet Archive is used.
    public var internetArchiveEnabled: Bool?
    /// Whether BrainzPlayer shows notifications.
    public var notificationsEnabled: Bool?
    /// The services in the order BrainzPlayer tries them, such as `["spotify", "youtube"]`.
    public var servicePriority: [String]?

    /// Creates preferences. Services left `nil` use ListenBrainz's defaults.
    public init(
        isEnabled: Bool? = nil,
        youtubeEnabled: Bool? = nil,
        spotifyEnabled: Bool? = nil,
        soundcloudEnabled: Bool? = nil,
        appleMusicEnabled: Bool? = nil,
        funkwhaleEnabled: Bool? = nil,
        navidromeEnabled: Bool? = nil,
        internetArchiveEnabled: Bool? = nil,
        notificationsEnabled: Bool? = nil,
        servicePriority: [String]? = nil
    ) {
        self.isEnabled = isEnabled
        self.youtubeEnabled = youtubeEnabled
        self.spotifyEnabled = spotifyEnabled
        self.soundcloudEnabled = soundcloudEnabled
        self.appleMusicEnabled = appleMusicEnabled
        self.funkwhaleEnabled = funkwhaleEnabled
        self.navidromeEnabled = navidromeEnabled
        self.internetArchiveEnabled = internetArchiveEnabled
        self.notificationsEnabled = notificationsEnabled
        self.servicePriority = servicePriority
    }

    enum CodingKeys: String, CodingKey {
        case isEnabled = "brainzplayerEnabled"
        case youtubeEnabled
        case spotifyEnabled
        case soundcloudEnabled
        case appleMusicEnabled
        case funkwhaleEnabled
        case navidromeEnabled
        case internetArchiveEnabled
        case notificationsEnabled
        case servicePriority = "dataSourcesPriority"
    }
}
