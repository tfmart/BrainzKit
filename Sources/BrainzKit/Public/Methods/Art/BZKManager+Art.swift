//
//  BZKManager+Art.swift
//  BrainzKit
//
//  Created by Tomas Martins on 18/11/26.
//

import Foundation

public extension BZKManager {
    /// The URL of a shareable SVG image of a user's top artists or releases.
    ///
    /// - Parameters:
    ///   - design: The image design.
    ///   - userName: The ListenBrainz user name.
    ///   - range: The statistics time range.
    ///   - size: The image's edge length in pixels.
    /// - Returns: The image URL.
    nonisolated func statsArtURL(_ design: BZKStatsArtDesign, forUser userName: String, range: BZKStatisticsRange = .allTime, size: Int = 750) -> URL? {
        URL(string: Self.baseURL + "art/\(design.rawValue)/\(BZKRequest.segment(userName))/\(range.rawValue)/\(size)")
    }

    /// The URL of an SVG grid of a user's top release covers.
    ///
    /// - Parameters:
    ///   - userName: The ListenBrainz user name.
    ///   - range: The statistics time range.
    ///   - dimension: The number of covers per row, from 2 to 5.
    ///   - layout: The tile layout for the dimension. Layout 0 is a plain grid; others give some covers more space.
    ///   - size: The image's edge length in pixels.
    /// - Returns: The image URL.
    nonisolated func coverArtGridURL(forUser userName: String, range: BZKStatisticsRange = .allTime, dimension: Int = 3, layout: Int = 0, size: Int = 750) -> URL? {
        URL(string: Self.baseURL + "art/grid-stats/\(BZKRequest.segment(userName))/\(range.rawValue)/\(dimension)/\(layout)/\(size)")
    }

    /// The URL of an SVG grid of an artist's most listened album covers.
    ///
    /// - Parameters:
    ///   - artistMBID: The MusicBrainz artist ID.
    ///   - dimension: The number of covers per row, from 2 to 5.
    ///   - layout: The tile layout for the dimension. Layout 0 is a plain grid; others give some covers more space.
    ///   - size: The image's edge length in pixels.
    /// - Returns: The image URL.
    nonisolated func artistCoverArtGridURL(forArtist artistMBID: String, dimension: Int = 3, layout: Int = 0, size: Int = 750) -> URL? {
        URL(string: Self.baseURL + "art/artist-grid/\(BZKRequest.segment(artistMBID))/\(dimension)/\(layout)/\(size)")
    }

    /// The URL of a PNG preview image for a playlist, as shown when sharing it on social media.
    ///
    /// - Parameter playlistID: The playlist's ID.
    /// - Returns: The image URL. Playlists without cover art redirect to a generic ListenBrainz image.
    nonisolated func playlistPreviewImageURL(forPlaylist playlistID: String) -> URL? {
        URL(string: Self.baseURL + "art/playlist/\(BZKRequest.segment(playlistID))/opengraph/")
    }

    /// The URL of a shareable SVG image from a user's Year in Music.
    ///
    /// - Parameters:
    ///   - image: Which image to create.
    ///   - userName: The ListenBrainz user name.
    ///   - year: The year.
    /// - Returns: The image URL. Loading it returns no content if ListenBrainz lacks the data for that year.
    nonisolated func yearInMusicArtURL(_ image: BZKYearInMusicArt, forUser userName: String, year: Int) -> URL? {
        URL(string: Self.baseURL + "art/year-in-music/\(year)/\(BZKRequest.segment(userName))?image=\(image.rawValue)")
    }

    /// Creates an SVG grid of release covers.
    ///
    /// - Parameters:
    ///   - releaseMBIDs: MusicBrainz release IDs, placed on the grid in order.
    ///   - dimension: The number of covers per row, from 2 to 5.
    ///   - layout: The tile layout for the dimension. Layout 0 is a plain grid; others give some covers more space.
    ///   - size: The image's edge length in pixels.
    ///   - background: The background behind the covers.
    ///   - showCaptions: Whether to show each release's name and artist over its cover.
    /// - Returns: The SVG image data.
    /// - Throws: ``BZKError`` with status 400 if the grid options are invalid.
    func coverArtGrid(
        releaseMBIDs: [String],
        dimension: Int = 3,
        layout: Int = 0,
        size: Int = 750,
        background: BZKArtBackground = .black,
        showCaptions: Bool = false
    ) async throws -> Data {
        let body = BZKCoverArtGridBody(
            releaseMBIDs: releaseMBIDs,
            dimension: dimension,
            layout: layout,
            imageSize: size,
            background: background.rawValue,
            skipMissing: true,
            showCAA: false,
            caption: showCaptions
        )
        return try await send(BZKRequest(method: .post, path: "art/grid/", body: encode(body)))
    }

    /// Creates an SVG grid of a playlist's album covers.
    ///
    /// - Parameters:
    ///   - playlistID: The playlist's ID.
    ///   - dimension: The number of covers per row, from 2 to 5.
    ///   - layout: The tile layout for the dimension. Layout 0 is a plain grid; others give some covers more space.
    /// - Returns: The SVG image data.
    /// - Throws: ``BZKClientError/missingToken`` if no user is signed in, or ``BZKError`` if the grid options are invalid or the user can't see the playlist.
    func playlistCoverArt(forPlaylist playlistID: String, dimension: Int = 3, layout: Int = 0) async throws -> Data {
        let request = try BZKRequest(
            method: .post,
            path: "art/playlist/\(BZKRequest.segment(playlistID))/\(dimension)/\(layout)",
            token: requiredToken()
        )
        return try await send(request)
    }
}
